defmodule Akedia.Workers.FaviconScraper do
  require Logger
  use Que.Worker
  alias Akedia.Repo
  alias Akedia.Content.Bookmark
  alias Akedia.Media
  alias Scrape.Website

  def perform(%Bookmark{url: bookmark_url} = bookmark) do
    case get_favicon(bookmark_url) do
      {:ok, favicon_url} ->
        favicon =
          bookmark_url
          |> URI.parse()
          |> Map.get(:host)
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
    case Scrape.website(url) do
      %Website{favicon: nil} ->
        {:error, :no_favicon_found}

      %Website{favicon: favicon} ->
        {:ok, favicon}
    end
  end
end
