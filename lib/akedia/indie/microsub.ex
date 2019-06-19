defmodule Akedia.Indie.Microsub do
  @moduledoc """
  The Indie.Microsub context.
  """

  import Ecto.Query, warn: false
  alias Akedia.Repo

  alias Akedia.Indie.Microsub.{Channel, Feed, FeedEntry}

  def list_channels do
    Channel
    |> Repo.all()
    |> Repo.preload(feeds: [:entries])
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

  def list_feed_entries_query(channel_id, limit \\ 10) do
    channel = get_channel!(channel_id)
    feed_ids = Enum.map(channel.feeds, fn f -> f.id end)

    FeedEntry
    |> where([e], e.feed_id in ^feed_ids)
    |> order_by(desc: :published_at)
    |> limit(^limit)
  end

  def list_feed_entries(channel_id, nil, nil) do
    entries =
      channel_id
      |> list_feed_entries_query()
      |> Repo.all()
  end

  def list_feed_entries(channel_id, paging_before, nil) do
    {:ok, date} = DateTime.from_unix(paging_before)

    entries =
      channel_id
      |> list_feed_entries_query()
      |> where([e], e.published_at > ^date)
      |> Repo.all()
  end

  def list_feed_entries(channel_id, nil, paging_after) do
    {:ok, date} = DateTime.from_unix(paging_after)

    entries =
      channel_id
      |> list_feed_entries_query()
      |> where([e], e.published_at < ^date)
      |> Repo.all()
  end
end
