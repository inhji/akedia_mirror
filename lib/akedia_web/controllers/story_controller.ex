defmodule AkediaWeb.StoryController do
  use AkediaWeb, :controller

  alias Akedia.Content
  alias Akedia.Content.Story

  def index(conn, _params) do
    stories = Content.list_stories()

    render_empty(conn, stories, stories: stories)
  end

  def new(conn, _params) do
    changeset = Content.change_story(%Story{})
    render(conn, "new.html", changeset: changeset, tags: [])
  end

  def create(conn, %{"story" => %{"topics" => topics} = story_params}) do
    case Content.create_story(story_params) do
      {:ok, story} ->
        Content.add_tags(story, topics)

        conn
        |> put_flash(:info, "Story created successfully.")
        |> redirect(to: Routes.story_path(conn, :show, story))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    story = Content.get_story!(id)
    render(conn, "show.html", story: story)
  end

  def edit(conn, %{"id" => id}) do
    story = Content.get_story!(id)
    tags = Content.tags_loaded(story)
    changeset = Content.change_story(story)
    render(conn, "edit.html", story: story, changeset: changeset, tags: tags)
  end

  def update(conn, %{"id" => id, "story" => %{"topics" => topics} = story_params}) do
    story = Content.get_story!(id)
    Content.update_tags(story, topics)

    case Content.update_story(story, story_params) do
      {:ok, story} ->
        conn
        |> put_flash(:info, "Story updated successfully.")
        |> redirect(to: Routes.story_path(conn, :show, story))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", story: story, changeset: changeset)
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
