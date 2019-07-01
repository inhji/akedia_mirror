defmodule Akedia.Workers.Feeder do
  use Que.Worker
  require Logger
  alias HTTPoison.Response
  alias Akedia.Feeds

  def perform(%{feed_id: feed_id}) do
    feed_id
    |> Feeds.get_feed!()
    |> process_feed()
  end

  def perform(_args) do
    Logger.info("Triggering Feed fetching")

    Feeds.list_feeds()
    |> Enum.map(&process_feed/1)
  end

  def process_feed(%Feeds.Feed{} = feed) do
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
    feed = Feeds.get_feed!(feed_id)

    Logger.info("Updating feed #{title}")

    Feeds.update_feed(feed, %{
      title: title,
      description: subtitle
    })

    parsed_feed
  end

  def update_feed_entries(%FeederEx.Feed{entries: entries, title: title} = parsed_feed, feed_id) do
    Logger.info("Inserting #{Enum.count(entries)} new items for #{title}")
    Enum.each(entries, &insert_feed_entry(&1, feed_id, title))
    parsed_feed
  end

  def insert_feed_entry(
        %FeederEx.Entry{
          author: author,
          summary: summary,
          title: title,
          link: url,
          updated: published_at
        },
        feed_id,
        feed_title
      ) do
    date =
      case published_at do
        nil -> DateTime.utc_now()
        d -> Akedia.DateTime.to_datetime_utc(d)
      end

    case Feeds.create_feed_entry(
           %{
             author: author || feed_title,
             summary: summary,
             title: title,
             url: url,
             published_at: date
           },
           feed_id
         ) do
      {:ok, _entry} ->
        Logger.debug("Entry inserted with title: #{title}")

      {:error, error} ->
        Logger.error("Could not insert entry: #{inspect(error)}")
    end
  end

  def fetch_feed(%Feeds.Feed{url: url} = _feed) do
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
