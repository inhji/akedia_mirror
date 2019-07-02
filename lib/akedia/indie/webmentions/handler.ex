defmodule Akedia.Indie.Webmentions.Handler do
  @behaviour Akedia.Plugs.PlugWebmention.HandlerBehaviour
  alias Akedia.Mentions
  alias Akedia.Indie.Helpers

  @impl true
  def handle_receive(%{:target => target, :post => post} = body) do
    with {:ok, author} <- maybe_create_author(post.author),
         {:ok, schema} <- Helpers.get_post_by_url(target) do
      entity_id = schema.entity.id

      mention =
        prepare_mention(body)
        |> Enum.into(prepare_wm_property(body))
        |> Enum.into(%{
          entity_id: entity_id,
          author_id: author.id
        })
        |> Mentions.create_mention()

      IO.inspect(post)
      IO.inspect(mention)
      :ok
    else
      _ -> {:error, "Bad Request"}
    end
  end

  def prepare_mention(%{:source => source, :target => target, :post => post} = body) do
    %{
      source: source,
      target: target,
      title: post.name,
      content_html: post.content.html,
      content_plain: post.content.text,
      url: post.url,
      published_at: Akedia.DateTime.to_datetime(post.published)
    }
  end

  def prepare_wm_property(%{:post => post} = body) do
    wm_property = Map.get(post, :"wm-property")
    result = %{wm_property: wm_property}

    case wm_property do
      "bookmark-of" -> Map.put(result, :bookmark_of, Map.get(post, :"bookmark-of"))
      "in-reply-to" -> Map.put(result, :in_reply_to, Map.get(post, :"in-reply-to"))
      "like-of" -> Map.put(result, :like_of, Map.get(post, :"like-of"))
      "repost-of" -> Map.put(result, :repost_of, Map.get(post, :"repost-of"))
    end
  end

  def maybe_create_author(author) do
    author =
      if author.url == "" do
        Map.put(author, :url, "https://example.com")
      end

    case Mentions.get_author_by_url(author.url) do
      nil ->
        case Mentions.create_author(author) do
          {:ok, author} -> {:ok, author}
          {:error, error} -> {:error, "Bad Request"}
        end

      author ->
        {:ok, author}
    end
  end
end
