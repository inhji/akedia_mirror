defmodule AkediaWeb.StoryController do
  use AkediaWeb, :controller

  alias Akedia.{Content, Media}
  alias Akedia.Content.Story

  def index(conn, _params) do
    stories =
      case logged_in?(conn) do
        true -> Content.list_stories()
        false -> Content.list_published_stories()
      end

    render_index_or_empty(conn, stories, stories: stories)
  end

  def new(conn, _params) do
    changeset = Content.change_story(%Story{})
    images = Media.list_images()

    render(conn, "new.html",
      changeset: changeset,
      tags: [],
      image_ids: [],
      images: images
    )
  end

  def create(conn, %{"story" => %{"topics" => topics, "images" => images} = story_params}) do
    case Content.create_story(story_params) do
      {:ok, story} ->
        Content.add_tags(story, topics)
        Media.add_images(story, images)

        conn
        |> put_flash(:info, "Story created successfully.")
        |> redirect(to: Routes.story_path(conn, :show, story))

      {:error, %Ecto.Changeset{} = changeset} ->
        images = Media.list_images()
        render(conn, "new.html", changeset: changeset, tags: [], image_ids: [], images: images)
    end
  end

  def show(conn, %{"id" => id}) do
    story = Content.get_story!(id)
    render(conn, "show.html", story: story)
  end

  def edit(conn, %{"id" => id}) do
    story = Content.get_story!(id)
    tags = Content.tags_loaded(story)
    image_ids = Media.images_loaded(story)
    changeset = Content.change_story(story)
    images = Media.list_images()

    render(conn, "edit.html",
      story: story,
      changeset: changeset,
      tags: tags,
      images: images,
      image_ids: image_ids
    )
  end

  def update(conn, %{
        "id" => id,
        "story" => %{"topics" => topics, "images" => images} = story_params
      }) do
    story = Content.get_story!(id)
    tags = Content.tags_loaded(story)
    image_ids = Media.images_loaded(story)
    Content.update_tags(story, topics)
    Media.update_images(story, images)

    case Content.update_story(story, story_params) do
      {:ok, story} ->
        conn
        |> put_flash(:info, "Story updated successfully.")
        |> redirect(to: Routes.story_path(conn, :show, story))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          story: story,
          changeset: changeset,
          tags: tags,
          images: images,
          image_ids: image_ids
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    story = Content.get_story!(id)
    {:ok, _story} = Content.delete_story(story)

    conn
    |> put_flash(:info, "Story deleted successfully.")
    |> redirect(to: Routes.story_path(conn, :index))
  end
end
