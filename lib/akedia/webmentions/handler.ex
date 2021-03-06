defmodule Akedia.Webmentions.Handler do
  @behaviour AkediaWeb.Plugs.PlugWebmention.HandlerBehaviour
  alias Akedia.Mentions

  require Logger

  @impl true
  def handle_receive(%{:target => target, :post => post} = body) do
    Logger.info("Receiving webmention from webmention.io!")
    Logger.info("Target: #{target}")

    IO.inspect(post)

    with {:ok, author} <- Akedia.Indie.maybe_create_author(post.author),
         {:ok, author} <- Akedia.Indie.update_author(author, %{photo: post.author.photo}),
         {:ok, schema} <- Akedia.entity_from_url(target) do
      entity_id = schema.entity.id

      prepare_mention(body)
      |> Enum.into(prepare_wm_property(body))
      |> Enum.into(%{
        entity_id: entity_id,
        author_id: author.id
      })
      |> Mentions.create_or_update_mention()

      Logger.info("Webmention handled!")

      :ok
    else
      {:error, error} ->
        Logger.warn("There was an error while handling the mention:")
        Logger.warn("#{inspect(error)}")

        {:error, "Bad Request"}

      _ ->
        Logger.warn("Unexpected error while handling the mention.")

        {:error, "Bad Request"}
    end
  end

  def handle_receive(%{deleted: true} = _body) do
    # TODO: Delete mention
  end

  def prepare_mention(%{:source => source, :target => target, :post => post} = _body) do
    content = Map.get(post, :content, %{})

    %{
      source: source,
      target: target,
      title: Map.get(post, :name),
      content_html: Map.get(content, :html),
      content_plain: Map.get(content, :text),
      url: Map.get(post, :url),
      published_at:
        Akedia.DateTime.to_datetime(post.published) ||
          Akedia.DateTime.to_datetime(post[:"wm-received"])
    }
  end

  def prepare_wm_property(%{:post => post} = _body) do
    wm_property = Map.get(post, :"wm-property")
    result = %{wm_property: wm_property}

    case wm_property do
      "bookmark-of" -> Map.put(result, :bookmark_of, Map.get(post, :"bookmark-of"))
      "in-reply-to" -> Map.put(result, :in_reply_to, Map.get(post, :"in-reply-to"))
      "like-of" -> Map.put(result, :like_of, Map.get(post, :"like-of"))
      "repost-of" -> Map.put(result, :repost_of, Map.get(post, :"repost-of"))
    end
  end
end
