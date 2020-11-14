defmodule AkediaWeb.PostFormLive do
  use AkediaWeb, :live
  alias Akedia.Content.{Post, Bookmark, Like}

  def mount(_params, _assigns, socket) do
    changeset = Post.changeset(%Post{}, %{})

    {:ok, assign(socket, changeset: changeset, type: "post", params: %{})}
  end

  def handle_event("change_type", %{"type" => type}, %{assigns: assigns} = socket) do
    changeset =
      if type !== assigns.type do
        get_changeset_by_type(assigns.params, type)
      else
        assigns.changeset
      end

    {:noreply, assign(socket, type: type, changeset: changeset, params: assigns.params)}
  end

  def handle_event("validate", %{"post" => params}, socket) do
    changeset =
      params
      |> get_changeset_by_type(socket.assigns.type)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset, params: params)}
  end

  def handle_event("save", %{"post" => params}, socket) do
    IO.inspect(params)

    result =
      case socket.assigns.type do
        "post" -> Akedia.Content.create_post(params)
        "like" -> Akedia.Content.create_like(params)
        "bookmark" -> Akedia.Content.create_bookmark(params)
      end

    IO.inspect(result)

    case result do
      {:ok, post} ->
        %{entity_id: post.entity_id}
        |> Akedia.Webmentions.Worker.new()
        |> Oban.insert()

        {:noreply,
         socket
         |> put_flash(:info, "Post created!")
         |> redirect(to: Routes.public_path(AkediaWeb.Endpoint, :index))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def get_changeset_by_type(changes, type) do
    case type do
      "post" -> Post.changeset(%Post{}, changes)
      "bookmark" -> Bookmark.changeset(%Bookmark{}, changes)
      "like" -> Like.changeset(%Like{}, changes)
    end
  end
end
