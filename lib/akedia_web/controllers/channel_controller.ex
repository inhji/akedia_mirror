defmodule AkediaWeb.ChannelController do
  use AkediaWeb, :controller

  alias Akedia.Feeds
  alias Akedia.Feeds.Channel

  def index(conn, _params) do
    channels = Feeds.list_channels()
    render(conn, "index.html", channels: channels)
  end

  def new(conn, _params) do
    changeset = Feeds.change_channel(%Channel{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"channel" => channel_params}) do
    case Feeds.create_channel(channel_params) do
      {:ok, channel} ->
        conn
        |> put_flash(:info, "Channel created successfully.")
        |> redirect(to: Routes.channel_path(conn, :show, channel))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    channel = Feeds.get_channel!(id)
    render(conn, "show.html", channel: channel)
  end

  def edit(conn, %{"id" => id}) do
    channel = Feeds.get_channel!(id)
    changeset = Feeds.change_channel(channel)
    render(conn, "edit.html", channel: channel, changeset: changeset)
  end

  def update(conn, %{"id" => id, "channel" => channel_params}) do
    channel = Feeds.get_channel!(id)

    case Feeds.update_channel(channel, channel_params) do
      {:ok, channel} ->
        conn
        |> put_flash(:info, "#{channel.name} updated successfully.")
        |> redirect(to: Routes.channel_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", channel: channel, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    channel = Feeds.get_channel!(id)
    {:ok, _channel} = Feeds.delete_channel(channel)

    conn
    |> put_flash(:info, "Channel deleted successfully.")
    |> redirect(to: Routes.channel_path(conn, :index))
  end
end
