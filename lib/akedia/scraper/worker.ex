defmodule Akedia.Scraper.Worker do
  require Logger
  use Que.Worker
  alias Akedia.Content.Like

  @like_scrape_attrs title: "title"

  def perform(%Like{url: url} = like) do
    case Akedia.Scraper.scrape(url, @like_scrape_attrs) do
      nil ->
        :ok

      {:ok, title: title} ->
        Akedia.Content.update_like(like, %{title: title})
    end
  end
end
