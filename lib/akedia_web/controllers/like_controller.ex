defmodule AkediaWeb.LikeController do
  use AkediaWeb, :controller

  alias Akedia.Content
  alias Akedia.Content.Like

  plug :check_user when action not in [:show]

  def index(conn, _params) do
    likes = Content.list_likes(is_published: true)
    render(conn, "index.html", likes: likes)
  end

  def drafts(conn, _params) do
    likes = Content.list_likes(is_published: false)
    render(conn, "index.html", likes: likes)
  end

  def new(conn, _params) do
    changeset = Content.change_like(%Like{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"like" => like_params}) do
    case Content.create_like(like_params) do
      {:ok, like} ->
        %{url: like.url, entity_id: like.entity.id}
        |> Akedia.Context.Worker.new()
        |> Oban.insert()

        %{entity_id: like.entity.id}
        |> Akedia.Webmentions.Worker.new()
        |> Oban.insert()

        conn
        |> put_flash(:info, "Like created successfully.")
        |> redirect(to: Routes.like_path(conn, :show, like))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    like = Content.get_like!(id)
    render(conn, "show.html", like: like)
  end

  def edit(conn, %{"id" => id}) do
    like = Content.get_like!(id)
    changeset = Content.change_like(like)
    render(conn, "edit.html", like: like, changeset: changeset)
  end

  def update(conn, %{"id" => id, "like" => like_params}) do
    like = Content.get_like!(id)

    case Content.update_like(like, like_params) do
      {:ok, like} ->
        %{url: like.url, entity_id: like.entity.id}
        |> Akedia.Context.Worker.new()
        |> Oban.insert()

        %{entity_id: like.entity.id}
        |> Akedia.Webmentions.Worker.new()
        |> Oban.insert()

        conn
        |> put_flash(:info, "Like updated successfully.")
        |> redirect(to: Routes.like_path(conn, :show, like))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", like: like, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    like = Content.get_like!(id)
    {:ok, _like} = Content.delete_like(like)

    conn
    |> put_flash(:info, "Like deleted successfully.")
    |> redirect(to: Routes.public_path(conn, :index))
  end
end
