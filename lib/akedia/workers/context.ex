defmodule Akedia.Workers.Context do
  require Logger
  use Que.Worker
  alias Akedia.Content.Like

  def perform(%Like{url: url, entity: entity} = like) do
    {:ok, %{items: [item]}} = Akedia.Indie.Microformats.fetch(url)

    [author] = get_in(item, [:properties, :author])

    %{
      name: [name],
      photo: [photo],
      url: [url]
    } = author.properties

    Akedia.Indie.maybe_create_author(%{
      name: name,
      photo: photo,
      url: url
    })
  end
end
