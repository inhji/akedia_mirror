defmodule AkediaWeb.PageController do
  use AkediaWeb, :controller

  alias Akedia.Content
  alias Akedia.Content.Page

  def index(conn, _params) do
    pages =
      case logged_in?(conn) do
        true -> Content.list_pages()
        false -> Content.list_published_pages()
      end

    render_index_or_empty(conn, pages, pages: pages)
  end

  def new(conn, _params) do
    changeset = Content.change_page(%Page{})
    render(conn, "new.html", changeset: changeset, tags: [])
  end

  def create(conn, %{"page" => %{"topics" => topics} = page_params}) do
    case Content.create_page(page_params) do
      {:ok, page} ->
        Content.add_tags(page, topics)

        conn
        |> put_flash(:info, "Page created successfully.")
        |> redirect(to: Routes.page_path(conn, :show, page))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    page = Content.get_page!(id)
    render(conn, "show.html", page: page)
  end

  def edit(conn, %{"id" => id}) do
    page = Content.get_page!(id)
    tags = Content.tags_loaded(page)
    changeset = Content.change_page(page)
    render(conn, "edit.html", page: page, changeset: changeset, tags: tags)
  end

  def update(conn, %{"id" => id, "page" => %{"topics" => topics} = page_params}) do
    page = Content.get_page!(id)
    Content.update_tags(page, topics)

    case Content.update_page(page, page_params) do
      {:ok, page} ->
        conn
        |> put_flash(:info, "Page updated successfully.")
        |> redirect(to: Routes.page_path(conn, :show, page))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", page: page, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    page = Content.get_page!(id)
    {:ok, _page} = Content.delete_page(page)

    conn
    |> put_flash(:info, "Page deleted successfully.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
