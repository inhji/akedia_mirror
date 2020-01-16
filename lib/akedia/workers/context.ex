defmodule Akedia.Workers.Context do
  require Logger
  use Que.Worker
  alias Akedia.Content.Like

  def perform(%Like{url: url, entity: entity} = like) do
    {:ok, %{items: [item]}} = Akedia.Indie.Microformats.fetch(url)

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

    Akedia.Indie.maybe_create_context(%{
      content: content,
      content_html: content_html,
      author_id: author.id,
      entity_id: entity.id,
      published_at: published_at,
      url: url
    })
  end
end
