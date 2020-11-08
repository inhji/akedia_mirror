defmodule AkediaWeb.PostController do
  use AkediaWeb, :controller

  alias Akedia.Content
  alias Akedia.Content.Post
  alias Akedia.Media

  plug :check_user when action not in [:show]

  def index(conn, _params) do
    posts = Content.list_posts(is_published: true)
    render(conn, "index.html", posts: posts)
  end

  def drafts(conn, _params) do
    posts = Content.list_posts(is_published: false)
    render(conn, "index.html", posts: posts)
  end

  def new(conn, %{"content" => content}) do
    changeset = Post.changeset(%Post{}, %{content: content})
    render(conn, "new.html", changeset: changeset, tags: [])
  end

  def new(conn, _params) do
    changeset = Post.changeset(%Post{}, %{})
    render(conn, "new.html", changeset: changeset, tags: [])
  end

  def create(conn, %{"post" => %{"topics" => topics} = post_params}) do
    IO.inspect(post_params)

    case Content.create_post(post_params) do
      {:ok, post} ->
        Content.add_tags(post, topics)

        Media.maybe_create_image(
          %{name: Map.get(post_params, "image", nil)},
          post.entity_id
        )

        %{entity_id: post.entity_id}
        |> Akedia.Webmentions.Worker.new()
        |> Oban.insert()

        conn
        |> redirect(to: Routes.public_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, tags: [])
    end
  end

  def show(conn, %{"id" => id}) do
    post = Content.get_post!(id)
    render(conn, "show.html", post: post)
  end

  def edit(conn, %{"id" => id}) do
    post = Content.get_post!(id)
    tags = Content.tags_loaded(post)
    changeset = Content.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset, tags: tags)
  end

  def update(conn, %{"id" => id, "post" => %{"topics" => topics} = post_params}) do
    post = Content.get_post!(id)
    Content.update_tags(post, topics)

    case Content.update_post(post, post_params) do
      {:ok, post} ->
        %{entity_id: post.entity_id}
        |> Akedia.Webmentions.Worker.new()
        |> Oban.insert()

        Media.maybe_update_image(post.entity.image, %{
          name: Map.get(post_params, "image", nil),
          entity_id: post.entity_id
        })

        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Content.get_post!(id)
    {:ok, _post} = Content.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.post_path(conn, :index))
  end
end
