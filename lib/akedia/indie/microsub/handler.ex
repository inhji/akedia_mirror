defmodule Akedia.Indie.Microsub.Handler do
  @behaviour AkediaWeb.Plugs.PlugMicrosub.HandlerBehaviour

  alias Akedia.Feeds

  @impl true
  def handle_list_channels() do
    channels =
      Feeds.list_channels()
      |> Enum.map(&prepare_channel/1)

    {:ok, channels}
  end

  @impl true
  def handle_timeline(channel, paging_before, paging_after) do
    case Feeds.get_channel_by_uid!(channel) do
      nil ->
        {:error, "Channel #{channel} does not exist"}

      channel ->
        entries = Feeds.list_feed_entries(channel.id, paging_before, paging_after)
        prepared = Enum.map(entries, &prepare_entry/1)
        paging = prepare_paging(entries)

        {:ok, prepared, paging}
    end
  end

  @impl true
  def handle_mark_read(channel, entry_ids) do
    case Feeds.get_channel_by_uid!(channel) do
      nil ->
        {:error, "Channel #{channel} does not exist"}

      _channel ->
        entry_ids
        |> Enum.map(fn id ->
          Feeds.mark_feed_entry(id, true)
        end)

        :ok
    end
  end

  @impl true
  def handle_mark_read_before(channel, before_id) do
    case Feeds.get_channel_by_uid!(channel) do
      nil ->
        {:error, "Channel #{channel} does not exist"}

      channel ->
        Feeds.list_feed_entries_before(channel.id, before_id)
        |> Enum.map(fn entry -> entry.id end)
        |> Enum.each(&Feeds.mark_feed_entry(&1, true))

        :ok
    end
  end

  def prepare_paging([]), do: %{}

  def prepare_paging(entries) do
    first = List.first(entries)
    last = List.last(entries)

    %{
      before: DateTime.to_unix(first.published_at),
      after: DateTime.to_unix(last.published_at)
    }
  end

  def prepare_entry(entry) do
    %{
      type: "entry",
      author: %{
        type: "card",
        name: entry.author
      },
      title: entry.title,
      url: entry.url,
      published: DateTime.to_iso8601(entry.published_at),
      content: %{
        text: HtmlSanitizeEx.strip_tags(entry.summary),
        html: entry.summary
      },
      _id: entry.id,
      _is_read: entry.is_read
    }
  end

  def prepare_channel(channel) do
    %{
      uid: channel.uid,
      name: channel.name,
      unread: get_unread_count(channel.feeds)
    }
  end

  def get_unread_count(feeds) do
    Enum.reduce(feeds, 0, fn feed, acc ->
      acc + Enum.count(feed.entries, fn e -> !e.is_read end)
    end)
  end
end
