defmodule Akedia.Workers.URLScraper do
  require Logger
  use Que.Worker
  alias Akedia.Repo
  alias Akedia.Content.{Bookmark}
  alias Scrape.Website

  def perform(%Bookmark{url: url} = bookmark) do
    %Website{title: title, favicon: favicon} = Scrape.website(url)

    IO.inspect(title)
    IO.inspect(favicon)

    attrs =
      %{title: title, favicon: favicon}
      |> Enum.reject(&is_nil/1)
      |> Enum.into(%{})

    bookmark
    |> Bookmark.changeset(attrs)
    |> Repo.update!()
  end
end
