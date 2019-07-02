defmodule AkediaWeb.FeedController do
  use AkediaWeb, :controller

  alias Akedia.Feeds
  alias Akedia.Feeds.Feed

  def index(conn, _params) do
    feeds = Feeds.list_feeds()
    render(conn, "index.html", feeds: feeds)
  end

  def new(conn, %{"channel_id" => channel_id}) do
    changeset = Feeds.change_feed(%Feed{})
    render(conn, "new.html", changeset: changeset, channel_id: channel_id)
  end

  def create(conn, %{"feed" => feed_params, "channel_id" => channel_id}) do
    channel = Feeds.get_channel!(channel_id)

    case Feeds.create_feed(feed_params, channel.id) do
      {:ok, feed} ->
        Que.add(Akedia.Workers.Feeder, %{feed_id: feed.id})

        conn
        |> put_flash(:info, "Feed created successfully.")
        |> redirect(to: Routes.channel_path(conn, :show, channel_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, channel_id: channel_id)
    end
  end

  def show(conn, %{"id" => id, "channel_id" => channel_id}) do
    feed = Feeds.get_feed!(id)
    render(conn, "show.html", feed: feed, channel_id: channel_id)
  end

  def edit(conn, %{"id" => id, "channel_id" => channel_id}) do
    feed = Feeds.get_feed!(id)
    changeset = Feeds.change_feed(feed)
    render(conn, "edit.html", feed: feed, changeset: changeset, channel_id: channel_id)
  end

  def update(conn, %{"id" => id, "feed" => feed_params, "channel_id" => channel_id}) do
    feed = Feeds.get_feed!(id)
    Que.add(Akedia.Workers.Feeder, %{feed_id: feed.id})

    case Feeds.update_feed(feed, feed_params) do
      {:ok, _feed} ->
        conn
        |> put_flash(:info, "Feed updated successfully.")
        |> redirect(to: Routes.channel_path(conn, :show, channel_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", feed: feed, changeset: changeset, channel_id: channel_id)
    end
  end

  def delete(conn, %{"id" => id, "channel_id" => channel_id}) do
    feed = Feeds.get_feed!(id)
    {:ok, _feed} = Feeds.delete_feed(feed)

    conn
    |> put_flash(:info, "Feed deleted successfully.")
    |> redirect(to: Routes.channel_path(conn, :show, channel_id))
  end
end
