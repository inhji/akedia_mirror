defmodule AkediaWeb.AlbumController do
  use AkediaWeb, :controller

  alias Akedia.Listens
  alias Akedia.Listens.Album

  def index(conn, _params) do
    albums = Listens.group_by_album(100)

    max_listens =
      albums
      |> List.first()
      |> Map.get(:listens)

    render(conn, "index.html", albums: albums, max_listens: max_listens)
  end

  def new(conn, _params) do
    changeset = Listens.change_album(%Album{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"album" => album_params}) do
    case Listens.create_album(album_params) do
      {:ok, album} ->
        conn
        |> put_flash(:info, "Album created successfully.")
        |> redirect(to: Routes.album_path(conn, :show, album))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    album = Listens.get_album!(id)
    render(conn, "show.html", album: album)
  end

  def edit(conn, %{"id" => id}) do
    album = Listens.get_album!(id)
    changeset = Listens.change_album(album)
    render(conn, "edit.html", album: album, changeset: changeset)
  end

  def update(conn, %{"id" => id, "album" => album_params}) do
    album = Listens.get_album!(id)

    case Listens.update_album(album, album_params) do
      {:ok, album} ->
        conn
        |> put_flash(:info, "Album updated successfully.")
        |> redirect(to: Routes.album_path(conn, :show, album))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", album: album, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    album = Listens.get_album!(id)
    {:ok, _album} = Listens.delete_album(album)

    conn
    |> put_flash(:info, "Album deleted successfully.")
    |> redirect(to: Routes.album_path(conn, :index))
  end
end
