defmodule AkediaWeb.PageController do
  use AkediaWeb, :controller

  alias Akedia.{Content, Media}
  alias Akedia.Content.Page

  def index(conn, _params) do
    pages = Content.list_pages(is_published: true, is_pinned: false)
    pinned = Content.list_pages(is_published: true, is_pinned: true)
    render(conn, "index.html", pages: pages, pinned: pinned)
  end

  def drafts(conn, _params) do
    pages = Content.list_pages(is_published: false, is_pinned: false)
    pinned = Content.list_pages(is_published: false, is_pinned: true)
    render(conn, "index.html", pages: pages, pinned: pinned)
  end

  def new(conn, _params) do
    changeset = Content.change_page(%Page{})
    images = Media.list_images()

    render(conn, "new.html", changeset: changeset, tags: [], images: images, image_ids: [])
  end

  def create(conn, %{"page" => %{"topics" => topics, "images" => images} = page_params}) do
    case Content.create_page(page_params) do
      {:ok, page} ->
        Content.add_tags(page, topics)
        Media.add_images(page, images)

        conn
        |> put_flash(:info, "Page created successfully.")
        |> redirect(to: Routes.page_path(conn, :show, page))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, tags: [], image_ids: [], images: images)
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
    image_ids = Media.images_loaded(page)
    images = Media.list_images()

    render(conn, "edit.html",
      page: page,
      changeset: changeset,
      tags: tags,
      images: images,
      image_ids: image_ids
    )
  end

  def update(conn, %{
        "id" => id,
        "page" => %{"topics" => topics, "images" => images} = page_params
      }) do
    page = Content.get_page!(id)
    image_ids = Media.images_loaded(page)
    tags = Content.tags_loaded(page)
    Content.update_tags(page, topics)
    Media.update_images(page, images)

    case Content.update_page(page, page_params) do
      {:ok, page} ->
        conn
        |> put_flash(:info, "Page updated successfully.")
        |> redirect(to: Routes.page_path(conn, :show, page))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          page: page,
          changeset: changeset,
          tags: tags,
          images: images,
          image_ids: image_ids
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
end
