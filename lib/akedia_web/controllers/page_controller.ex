defmodule AkediaWeb.PageController do
  use AkediaWeb, :controller

  alias Akedia.{Content, Media}
  alias Akedia.Content.Page

  plug :plug_pinned_fallback

  def index(conn, _params) do
    home_page = Content.get_home_page()
    pinned = Content.list_pages(is_published: true, is_pinned: true)
    render(conn, "index.html", pinned: pinned, home_page: home_page)
  end

  def drafts(conn, _params) do
    home_page = Content.get_home_page()
    pinned = Content.list_pages(is_published: false, is_pinned: true)
    render(conn, "index.html", pinned: pinned, home_page: home_page)
  end

  def new(conn, _params) do
    changeset = Content.change_page(%Page{})
    render(conn, "new.html", changeset: changeset, tags: [])
  end

  def create(conn, %{"page" => %{"topics" => topics, "entity" => entity} = page_params}) do
    case Content.create_page(page_params, entity) do
      {:ok, page} ->
        Content.add_tags(page, topics)

        conn
        |> put_flash(:info, "Page created successfully.")
        |> redirect(to: Routes.page_path(conn, :show, page))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, tags: [])
    end
  end

  def show(conn, %{"id" => id}) do
    page = Content.get_page!(id)
    pinned = Content.list_pages(is_published: true, is_pinned: true)
    render(conn, "show.html", page: page, pinned: pinned)
  end

  def edit(conn, %{"id" => id}) do
    page = Content.get_page!(id)
    tags = Content.tags_loaded(page)
    changeset = Content.change_page(page)

    render(conn, "edit.html",
      page: page,
      changeset: changeset,
      tags: tags
    )
  end

  def update(conn, %{"id" => id, "page" => %{"topics" => topics} = page_params}) do
    page = Content.get_page!(id)
    tags = Content.tags_loaded(page)
    Content.update_tags(page, topics)

    case Content.update_page(page, page_params) do
      {:ok, page} ->
        conn
        |> put_flash(:info, "Page updated successfully.")
        |> redirect(to: Routes.page_path(conn, :show, page))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          page: page,
          changeset: changeset,
          tags: tags
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    page = Content.get_page!(id)
    {:ok, _page} = Content.delete_page(page)

    conn
    |> put_flash(:info, "Page deleted successfully.")
    |> redirect(to: Routes.page_path(conn, :index))
  end

  def plug_pinned_fallback(%{:assigns => assigns} = conn, _params) do
    assign(conn, :pinned, Map.get(assigns, :pinned, []))
  end
end
