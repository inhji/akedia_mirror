defmodule Akedia.Scraper.Worker do
  require Logger
  use Oban.Worker, 
    queue: :default,
    max_attempts: 3

  @like_scrape_attrs title: "title"

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{entity_id: entity_id}}) do
    entity = Akedia.Content.get_entity!(entity_id)

    case Akedia.Scraper.scrape(entity.like.url, @like_scrape_attrs) do
      nil ->
        :ok

      {:ok, title: title} ->
        Akedia.Content.update_like(entity.like, %{title: title})
    end
  end
end
