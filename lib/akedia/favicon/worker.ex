defmodule Akedia.Favicon.Worker do
  require Logger
  use Que.Worker
  alias Akedia.{Repo, Media}
  alias Akedia.Content.Bookmark
  alias Akedia.Indie.{Microformats}
  alias Akedia.Indie.Microformats.HCard

  def perform(%Bookmark{url: bookmark_url} = bookmark) do
    case get_favicon(bookmark_url) do
      nil ->
        Logger.debug("No favicon found for #{bookmark_url}")

      favicon_url ->
        Logger.debug(favicon_url)

        favicon =
          bookmark_url
          |> Akedia.Helpers.hostname()
          |> maybe_create_favicon(favicon_url)

        bookmark
        |> Bookmark.changeset(%{favicon_id: favicon.id})
        |> Repo.update!()
    end
  end

  def maybe_create_favicon(hostname, favicon_url) do
    case Media.get_favicon(hostname) do
      nil ->
        {:ok, favicon} = Media.create_favicon(%{hostname: hostname, name: favicon_url})
        favicon

      favicon ->
        favicon
    end
  end

  def maybe_get_favicon_from_hcard(url) do
    with {:ok, properties} <- Microformats.fetch_hcard(url),
         {:ok, %HCard{photo: photo}} <- HCard.parse(properties) do
      {:ok, photo}
    else
      {:error, _} -> {:error, :no_favicon_in_hcard}
    end
  end

  def maybe_get_favicon_from_head(url) do
    case Akedia.Favicon.fetch(url) do
      {:ok, favicon} ->
        {:ok, favicon}

      {:error, _error} ->
        {:error, :no_favicon_in_head}
    end
  end

  def get_favicon(url) do
    Enum.reduce_while(
      [
        &maybe_get_favicon_from_hcard/1,
        &maybe_get_favicon_from_head/1
      ],
      nil,
      fn strategy, acc ->
        case strategy.(url) do
          {:error, _} -> {:cont, acc}
          {:ok, favicon} -> {:halt, favicon}
        end
      end
    )
  end
end
