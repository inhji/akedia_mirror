defmodule AkediaWeb.BookmarkController do
  use AkediaWeb, :controller

  alias Akedia.Content
  alias Akedia.Content.Bookmark

  def index(conn, _params) do
    bookmarks =
      case logged_in?(conn) do
        true -> Content.list_bookmarks()
        false -> Content.list_published_bookmarks()
      end

    render_index_or_empty(conn, bookmarks, bookmarks: bookmarks)
  end

  def new(conn, _params) do
    changeset = Content.change_bookmark(%Bookmark{})
    render(conn, "new.html", changeset: changeset, tags: [])
  end

  def create(conn, %{"bookmark" => %{"topics" => topics} = bookmark_params}) do
    case Content.create_bookmark(bookmark_params) do
      {:ok, bookmark} ->
        Content.add_tags(bookmark, topics)

        conn
        |> put_flash(:info, "Bookmark created successfully.")
        |> redirect(to: Routes.bookmark_path(conn, :show, bookmark))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, tags: [])
    end
  end

  def show(conn, %{"id" => id}) do
    bookmark = Content.get_bookmark!(id)
    render(conn, "show.html", bookmark: bookmark)
  end

  def edit(conn, %{"id" => id}) do
    bookmark = Content.get_bookmark!(id)
    tags = Content.tags_loaded(bookmark)
    changeset = Content.change_bookmark(bookmark)
    render(conn, "edit.html", bookmark: bookmark, changeset: changeset, tags: tags)
  end

  def update(conn, %{"id" => id, "bookmark" => %{"topics" => topics} = bookmark_params}) do
    bookmark = Content.get_bookmark!(id)
    Content.update_tags(bookmark, topics)

    case Content.update_bookmark(bookmark, bookmark_params) do
      {:ok, bookmark} ->
        conn
        |> put_flash(:info, "Bookmark updated successfully.")
        |> redirect(to: Routes.bookmark_path(conn, :show, bookmark))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", bookmark: bookmark, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    bookmark = Content.get_bookmark!(id)
    {:ok, _bookmark} = Content.delete_bookmark(bookmark)

    conn
    |> put_flash(:info, "Bookmark deleted successfully.")
    |> redirect(to: Routes.bookmark_path(conn, :index))
  end
end
