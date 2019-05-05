defmodule Akedia.Workers.URLScraper do
  require Logger
  use Que.Worker
  alias Akedia.Repo
  alias Akedia.Content.{Bookmark}
  alias Scrape.Website

  @bookmark_scrape_attrs [:title, :favicon]

  def perform(%Bookmark{url: url} = bookmark) do
    website = Scrape.website(url)

    attrs =
      @bookmark_scrape_attrs
      |> Enum.reduce(%{}, fn attr, attrs ->
        case Map.get(bookmark, attr) do
          nil -> Map.put(attrs, attr, Map.get(website, attr))
          _ -> attrs
        end
      end)

    bookmark
    |> Bookmark.changeset(attrs)
    |> Repo.update!()
  end
end
