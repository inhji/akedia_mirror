defmodule AkediaWeb.ArtistController do
  use AkediaWeb, :controller

  alias Akedia.Listens
  alias Akedia.Listens.Artist

  def index(conn, %{"last" => timespan}) do
    listens =
      case timespan do
        "hour" -> Listens.group_by_artist(hours: -1)
        "week" -> Listens.group_by_artist(weeks: -1)
        "month" -> Listens.group_by_artist(months: -1)
        "day" -> Listens.group_by_artist(days: -1)
        _ -> []
      end

    max_value = max_listen_value(listens)
    render(conn, "index.html", listens: listens, max: max_value)
  end

  def index(conn, _params) do
    listens = Listens.group_by_artist()
    max_value = max_listen_value(listens)
    render(conn, "index.html", listens: listens, max: max_value)
  end

  def new(conn, _params) do
    changeset = Listens.change_artist(%Artist{})
    render(conn, "new.html", changeset: changeset)
  end

  def show(conn, %{"id" => artist_id}) do
    artist = Listens.get_artist!(artist_id)

    popular_tracks =
      case artist do
        nil -> []
        artist -> Listens.group_by_track_artist(artist)
      end

    popular_tracks =
      Enum.map(popular_tracks, fn track ->
        album = Listens.get_album!(track.album_id)

        %{
          name: track.track,
          album: album,
          listens: track.listens
        }
      end)

    render(conn, "show.html",
      popular_tracks: popular_tracks,
      artist: artist
    )
  end

  def edit(conn, %{"id" => id}) do
    artist = Listens.get_artist!(id)
    changeset = Listens.change_artist(artist)
    render(conn, "edit.html", artist: artist, changeset: changeset)
  end

  def update(conn, %{"id" => id, "artist" => artist_params}) do
    artist = Listens.get_artist!(id)

    case Listens.update_artist(artist, artist_params) do
      {:ok, artist} ->
        conn
        |> put_flash(:info, "Artist updated successfully.")
        |> redirect(to: Routes.artist_path(conn, :show, artist))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", artist: artist, changeset: changeset)
    end
  end

  defp max_listen_value(grouped_listens) do
    grouped_listens
    |> Enum.max_by(
      fn l -> l.listens end,
      fn -> %{listens: 0} end
    )
    |> Map.get(:listens)
  end

  # def delete(conn, %{"id" => id}) do
  #   artist = Listens.get_artist!(id)
  #   {:ok, _artist} = Listens.delete_artist(artist)
  #
  #   conn
  #   |> put_flash(:info, "Artist deleted successfully.")
  #   |> redirect(to: Routes.artist_path(conn, :index))
  # end

  # def create(conn, %{"artist" => artist_params}) do
  #   case Listens.create_artist(artist_params) do
  #     {:ok, artist} ->
  #       conn
  #       |> put_flash(:info, "Artist created successfully.")
  #       |> redirect(to: Routes.artist_path(conn, :show, artist))
  #
  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "new.html", changeset: changeset)
  #   end
  # end
end
