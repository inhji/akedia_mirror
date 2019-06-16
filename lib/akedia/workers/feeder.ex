defmodule Akedia.Workers.Feeder do
  use Que.Worker
  require Logger
  alias HTTPoison.Response
  alias Akedia.Indie.Microsub

  def perform(%{feed_id: feed_id}) do
    feed_id
    |> Microsub.get_feed!()
    |> process_feed()
  end

  def perform(_args) do
    Logger.info("Triggering Feed fetching")

    Microsub.list_feeds()
    |> Enum.map(&process_feed/1)
  end

  def process_feed(%Microsub.Feed{} = feed) do
    Logger.info("Processing feed #{feed.url}")

    case fetch_feed(feed) do
      nil ->
        nil

      xml ->
        xml
        |> FeederEx.parse!()
        |> update_feed(feed.id)
        |> update_feed_entries(feed.id)
    end
  end

  def update_feed(%FeederEx.Feed{title: title, subtitle: subtitle} = parsed_feed, feed_id) do
    feed = Microsub.get_feed!(feed_id)

    Microsub.update_feed(feed, %{
      title: title,
      description: subtitle
    })

    parsed_feed
  end

  def update_feed_entries(%FeederEx.Feed{entries: entries} = parsed_feed, feed_id) do
    Enum.each(entries, &insert_feed_entry(&1, feed_id))

    parsed_feed
  end

  def insert_feed_entry(
        %FeederEx.Entry{author: author, summary: summary, title: title, link: url},
        feed_id
      ) do
    Microsub.create_feed_entry(
      %{
        author: author,
        summary: summary,
        title: title,
        url: url
      },
      feed_id
    )
  end

  def fetch_feed(%Microsub.Feed{url: url} = _feed) do
    case Akedia.HTTP.get!(url) do
      %Response{body: body, status_code: 200} ->
        body

      %Response{status_code: 404} ->
        Logger.info("Feed #{url} returned Not Found")
        nil

      %Response{status_code: status} ->
        Logger.info("Feed #{url} returned #{status}")
        nil
    end
  end
end
