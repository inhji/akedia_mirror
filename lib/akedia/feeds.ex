defmodule Akedia.Feeds do
  @moduledoc """
  The Indie.Feeds context.
  """

  @default_entry_limit 10

  import Ecto.Query, warn: false
  alias Akedia.Repo

  alias Akedia.Feeds.{Channel, Feed, FeedEntry}

  def list_channels do
    notification_channel = get_notification_channel()
    user_channels = list_user_channels()

    [notification_channel | user_channels]
  end

  def list_user_channels do
    query =
      from c in Channel,
        where: c.uid != "notifications",
        preload: [feeds: [:entries]]

    Repo.all(query)
  end

  def get_channel!(id) do
    Channel
    |> Repo.get!(id)
    |> Repo.preload(feeds: [:entries])
  end

  def get_channel_by_uid!(uid) do
    Channel
    |> Repo.get_by!(uid: uid)
    |> Repo.preload(feeds: [:entries])
  end

  def get_notification_channel() do
    Channel
    |> Repo.get_by!(uid: "notifications")
    |> Repo.preload(feeds: [:entries])
  end

  def create_channel(attrs \\ %{}) do
    %Channel{uid: Ecto.UUID.generate()}
    |> Channel.changeset(%{name: attrs["name"]})
    |> Repo.insert()
  end

  def update_channel(%Channel{} = channel, attrs) do
    channel
    |> Channel.changeset(attrs)
    |> Repo.update()
  end

  def delete_channel(%Channel{} = channel) do
    Repo.delete(channel)
  end

  def change_channel(%Channel{} = channel) do
    Channel.changeset(channel, %{})
  end

  def list_feeds do
    Repo.all(Feed)
  end

  def get_feed!(id) do
    Repo.get!(Feed, id)
    |> Repo.preload(:entries)
  end

  def create_feed(attrs \\ %{}, channel_id) do
    %Feed{channel_id: channel_id}
    |> Feed.changeset(attrs)
    |> Repo.insert()
  end

  def update_feed(%Feed{} = feed, attrs) do
    feed
    |> Feed.changeset(attrs)
    |> Repo.update()
  end

  def delete_feed(%Feed{} = feed) do
    Repo.delete(feed)
  end

  def change_feed(%Feed{} = feed) do
    Feed.changeset(feed, %{})
  end

  def create_feed_entry(attrs \\ %{}, feed_id) do
    %FeedEntry{feed_id: feed_id}
    |> FeedEntry.changeset(attrs)
    |> Repo.insert()
  end

  def list_unread_entries() do
    FeedEntry
    |> select([entry, f, c], entry)
    |> join(:left, [entry], f in Feed, on: entry.feed_id == f.id)
    |> where(is_read: false)
    |> order_by([e], desc: e.published_at)
    |> Repo.all()
  end

  def list_feed_entries_query(channel_id) do
    channel = get_channel!(channel_id)
    feed_ids = Enum.map(channel.feeds, fn f -> f.id end)

    FeedEntry
    |> where([e], e.feed_id in ^feed_ids)
    |> order_by(desc: :published_at)
  end

  def list_feed_entries(channel_id, nil, nil) do
    channel_id
    |> list_feed_entries_query()
    |> limit(^@default_entry_limit)
    |> Repo.all()
  end

  def list_feed_entries(channel_id, paging_before, nil) do
    {:ok, date} = DateTime.from_unix(paging_before)

    channel_id
    |> list_feed_entries_query()
    |> where([e], e.published_at > ^date)
    |> limit(^@default_entry_limit)
    |> Repo.all()
  end

  def list_feed_entries(channel_id, nil, paging_after) do
    {:ok, date} = DateTime.from_unix(paging_after)

    channel_id
    |> list_feed_entries_query()
    |> where([e], e.published_at < ^date)
    |> limit(^@default_entry_limit)
    |> Repo.all()
  end

  def list_feed_entries_before(channel_id, entry_id) do
    channel_id
    |> list_feed_entries_query()
    |> where([e], e.id < ^entry_id)
    |> Repo.all()
  end

  def get_feed_entry!(id) do
    Repo.get!(FeedEntry, id)
  end

  def get_feed_entry(id) do
    Repo.get(FeedEntry, id)
  end

  def update_feed_entry(%FeedEntry{} = entry, attrs) do
    entry
    |> FeedEntry.changeset(attrs)
    |> Repo.update()
  end

  def mark_feed_entry(id, mark_read) do
    case Repo.get(FeedEntry, id) do
      nil ->
        nil

      entry ->
        update_feed_entry(entry, %{is_read: mark_read})
    end
  end
end
