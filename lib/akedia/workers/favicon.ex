defmodule Akedia.Workers.Favicon do
  require Logger
  use Que.Worker
  alias Akedia.{Repo, Media, HTTP}
  alias Akedia.Content.Bookmark
  alias Akedia.Indie.{Microformats, Favicon}

  def perform(%Bookmark{url: bookmark_url} = bookmark) do
    case get_favicon(bookmark_url) do
      {:ok, favicon_url} ->
        Logger.debug("Favicon: #{favicon_url}")

        favicon =
          bookmark_url
          |> HTTP.hostname()
          |> maybe_create_favicon(favicon_url)

        bookmark
        |> Bookmark.changeset(%{favicon_id: favicon.id})
        |> Repo.update!()

      {:error, :no_favicon_found} ->
        Logger.debug("No favicon found for #{bookmark_url}")
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

  def get_favicon(url) do
    case Microformats.fetch_hcard(url) do
      {:ok, properties} ->
        hcard = Microformats.HCard.parse(properties)
        {:ok, hcard.photo}

      {:error, _error} ->
        case Favicon.fetch(url) do
          {:ok, favicon} ->
            {:ok, favicon}

          {:error, _error} ->
            {:error, :no_favicon_found}
        end
    end
  end
end
