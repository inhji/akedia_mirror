defmodule Akedia.Indie.Microsub.Handler do
  @behaviour Akedia.Plugs.PlugMicrosub.HandlerBehaviour

  alias Akedia.Indie.Microsub

  @impl true
  def handle_list_channels() do
    notification_channel =
      Akedia.Indie.Microsub.get_notification_channel()
      |> prepare_channel()

    other_channels =
      Microsub.list_channels()
      |> Enum.filter(fn c -> c.uid != "notifications" end)
      |> Enum.map(&prepare_channel/1)

    channels = [notification_channel | other_channels]

    {:ok, channels}
  end

  @impl true
  def handle_timeline(channel, paging_before, paging_after) do
    case Microsub.get_channel_by_uid!(channel) do
      nil ->
        {:error, "Channel #{channel} does not exist"}

      channel ->
        entries = Microsub.list_feed_entries(channel.id, paging_before, paging_after)
        prepared = Enum.map(entries, &prepare_entry/1)
        paging = prepare_paging(entries)

        {:ok, prepared, paging}
    end
  end

  @impl true
  def handle_mark_read(channel, entry_ids) do
    case Microsub.get_channel_by_uid!(channel) do
      nil ->
        {:error, "Channel #{channel} does not exist"}

      channel ->
        entry_ids
        |> Enum.map(fn id ->
          Microsub.mark_feed_entry(id, true)
        end)

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
      name: channel.name
    }
  end
end
