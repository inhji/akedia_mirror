defmodule AkediaWeb.ImageController do
  use AkediaWeb, :controller

  alias Akedia.Media
  alias Akedia.Media.Image

  plug :check_user when action not in [:show]

  def index(conn, _params) do
    images = Media.list_images()
    render(conn, "index.html", images: images)
  end

  def new(conn, _params) do
    changeset = Media.change_image(%Image{})
    render(conn, "new.html", changeset: changeset)
  end

  @spec create(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def create(conn, %{"image" => image_params}) do
    case Media.create_image(image_params) do
      {:ok, image} ->
        conn
        |> put_flash(:info, "Image created successfully.")
        |> redirect(to: Routes.image_path(conn, :show, image))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    image = Media.get_image!(id)
    render(conn, "show.html", image: image)
  end

  def edit(conn, %{"id" => id}) do
    image = Media.get_image!(id)
    changeset = Media.change_image(image)
    render(conn, "edit.html", image: image, changeset: changeset)
  end

  def update(conn, %{"id" => id, "image" => image_params}) do
    image = Media.get_image!(id)

    case Media.update_image(image, image_params) do
      {:ok, image} ->
        conn
        |> put_flash(:info, "Image updated successfully.")
        |> redirect(to: Routes.image_path(conn, :show, image))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", image: image, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    image = Media.get_image!(id)

    case Media.delete_image(image) do
      {:ok, _image} ->
        conn
        |> put_flash(:info, "Image deleted successfully.")
        |> redirect(to: Routes.image_path(conn, :index))

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Image could not be deleted.")
        |> redirect(to: Routes.image_path(conn, :show, image))
    end
  end
end
