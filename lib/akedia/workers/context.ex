defmodule Akedia.Workers.Context do
  require Logger
  use Que.Worker
  alias Akedia.Content.Like

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
            photo: photo,
            url: author_url
          })

        IO.inspect(Akedia.DateTime.to_datetime_utc(published_at))

        Akedia.Indie.maybe_create_context(%{
          content: content,
          content_html: content_html,
          author_id: author.id,
          entity_id: entity.id,
          published_at: Akedia.DateTime.to_datetime_utc(published_at),
          url: url
        })

      _ ->
        Logger.warn("Url #{url} does not contain microformats")
    end
  end
end
