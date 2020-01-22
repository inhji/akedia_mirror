defmodule Akedia.Workers.Context do
  require Logger
  use Que.Worker
  alias Akedia.Content.Like

  def find_node_info(url) do
    host = Akedia.HTTP.hostname(url)

    case Akedia.HTTP.get_json("https://#{host}/.well-known/nodeinfo") do
      {:ok, %{status_code: 200, body: body}} ->
        nodeinfo_url =
          body
          |> Jason.decode!()
          |> Map.get("links")
          |> hd
          |> Map.get("href")

        {:ok, nodeinfo_url}

      error ->
        IO.inspect(error)
        {:error, :no_nodeinfo_found}
    end
  end

  def fetch_node_info(url) do
    with {:ok, nodeinfo_url} <- find_node_info(url),
         {:ok, %{status_code: 200, body: body}} <- Akedia.HTTP.get_json(nodeinfo_url),
         {:ok, json} <- Jason.decode!(body) do
      {:ok, json}
    else
      error -> error
    end
  end

  def perform(%Like{url: url, entity: entity} = _like) do
    case Akedia.Indie.Microformats.fetch(url) do
      {:ok, %{items: [item]}} ->
        [author] = get_in(item, [:properties, :author])
        [content_map] = get_in(item, [:properties, :content])
        [published_at] = get_in(item, [:properties, :published])
        [url] = get_in(item, [:properties, :url])

        %{
          name: [name],
          photo: [photo],
          url: [author_url]
        } = author.properties

        %{html: content_html, text: content} = content_map

        {:ok, author} =
          Akedia.Indie.maybe_create_author(%{
            name: name,
            url: author_url
          })

        Akedia.Indie.update_author(author, %{photo: photo})

        {:ok, context} =
          Akedia.Indie.maybe_create_context(%{
            content: content,
            content_html: content_html,
            author_id: author.id,
            entity_id: entity.id,
            published_at: Akedia.DateTime.to_datetime_utc(published_at),
            url: url
          })

        case OpenGraph.fetch(url) do
          {:ok, %{image: context_photo}} ->
            IO.inspect(context_photo)
            Akedia.Indie.update_context(context, %{photo: context_photo})

          _ ->
            Logger.warn("Url #{url} does not contain opengraph data")
        end

      _ ->
        Logger.warn("Url #{url} does not contain microformats")
    end
  end
end
