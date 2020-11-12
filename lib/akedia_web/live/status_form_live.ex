defmodule AkediaWeb.StatusFormLive do
  use AkediaWeb, :live
  alias Akedia.Content.Post

  def mount(_params, _assigns, socket) do
    changeset = Post.changeset(%Post{}, %{})

    {:ok, assign(socket, changeset: changeset)}
  end

  def handle_event("validate", %{"post" => params}, socket) do
    changeset =
      %Post{}
      |> Post.changeset(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    case Akedia.Content.create_post(post_params) do
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

  def handle_event("more", _params, socket) do
    changeset = socket.assigns.changeset

    query_params =
      case changeset.valid? do
        true -> %{:content => Ecto.Changeset.get_change(changeset, :content)}
        _ -> %{}
      end

    {:noreply,
     socket
     |> redirect(to: Routes.post_path(AkediaWeb.Endpoint, :new, query_params))}
  end
end
