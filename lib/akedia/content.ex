defmodule Akedia.Content do
  import Ecto.Query, warn: false
  alias Akedia.Repo

  alias Akedia.Content.Entity

  def list_entities do
    Repo.all(Entity)
  end

  def get_entity!(id), do: Repo.get!(Entity, id)

  def create_entity(attrs \\ %{}) do
    %Entity{}
    |> Entity.changeset(attrs)
    |> Repo.insert()
  end

  def update_entity(%Entity{} = entity, attrs) do
    entity
    |> Entity.changeset(attrs)
    |> Repo.update()
  end

  def delete_entity(entity_id) when is_integer(entity_id) do
    entity = Repo.get!(Entity, entity_id)
    delete_entity(entity)
  end

  def delete_entity(%Entity{} = entity) do
    Repo.delete(entity)
  end

  def change_entity(%Entity{} = entity) do
    Entity.changeset(entity, %{})
  end

  alias Akedia.Content.Story

  def list_stories do
    list(Story, asc: :inserted_at)
  end

  def get_story!(id), do: Repo.get!(Story, id) |> Repo.preload(entity: [:topics, :images])

  def create_story(attrs \\ %{}) do
    {:ok, entity} = create_entity()

    %Story{}
    |> Story.changeset(Map.put(attrs, "entity_id", entity.id))
    |> Repo.insert()
  end

  def update_story(%Story{} = story, attrs) do
    story
    |> Story.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:entity, with: &Entity.changeset/2)
    |> Repo.update()
  end

  def delete_story(%Story{} = story) do
    Repo.delete(story)
    delete_entity(story.entity_id)
  end

  def change_story(%Story{} = story) do
    Story.changeset(story, %{})
  end

  alias Akedia.Content.Page

  def list_pages do
    list(Page, asc: :inserted_at)
  end

  def get_page!(id), do: Repo.get!(Page, id) |> Repo.preload(entity: [:topics])

  def create_page(attrs \\ %{}) do
    {:ok, entity} = create_entity()

    %Page{}
    |> Page.changeset(Map.put(attrs, "entity_id", entity.id))
    |> Repo.insert()
  end

  def update_page(%Page{} = page, attrs) do
    page
    |> Page.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:entity, with: &Entity.changeset/2)
    |> Repo.update()
  end

  def delete_page(%Page{} = page) do
    Repo.delete(page)
    delete_entity(page.entity_id)
  end

  def change_page(%Page{} = page) do
    Page.changeset(page, %{})
  end

  alias Akedia.Content.Bookmark

  def list_bookmarks do
    list(Bookmark, asc: :inserted_at)
  end

  def get_bookmark!(id), do: Repo.get!(Bookmark, id) |> Repo.preload(entity: [:topics])

  def create_bookmark(attrs \\ %{}) do
    {:ok, entity} = create_entity()

    %Bookmark{}
    |> Bookmark.changeset(Map.put(attrs, "entity_id", entity.id))
    |> Repo.insert()
  end

  def update_bookmark(%Bookmark{} = bookmark, attrs) do
    bookmark
    |> Bookmark.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:entity, with: &Entity.changeset/2)
    |> Repo.update()
  end

  def delete_bookmark(%Bookmark{} = bookmark) do
    Repo.delete(bookmark)
    delete_entity(bookmark.entity_id)
  end

  def change_bookmark(%Bookmark{} = bookmark) do
    Bookmark.changeset(bookmark, %{})
  end

  alias Akedia.Content.Topic

  def list_topics do
    Topic
    |> Repo.all()
    |> Repo.preload(entities: [:bookmark, :story, :page])
  end

  def get_topic!(id) do
    Topic
    |> Repo.get!(id)
    |> Repo.preload(entities: [:bookmark, :story, :page])
  end

  def create_topic(attrs \\ %{}) do
    %Topic{}
    |> Topic.changeset(attrs)
    |> Repo.insert()
  end

  def update_topic(%Topic{} = topic, attrs) do
    topic
    |> Topic.changeset(attrs)
    |> Repo.update()
  end

  def delete_topic(%Topic{} = topic) do
    Repo.delete(topic)
  end

  def change_topic(%Topic{} = topic) do
    Topic.changeset(topic, %{})
  end

  alias Akedia.Content.EntityTopic

  def add_tag(entity, topic_text) when is_binary(topic_text) do
    topic =
      case Repo.get_by(Topic, %{text: topic_text}) do
        nil ->
          %Topic{}
          |> Topic.changeset(%{text: topic_text})
          |> Repo.insert!()

        topic ->
          topic
      end

    add_tag(entity, topic.id)
  end

  def add_tag(%{entity_id: entity_id}, topic_id) do
    add_tag(entity_id, topic_id)
  end

  def add_tag(%Entity{} = entity, topic_id) do
    add_tag(entity.id, topic_id)
  end

  def add_tag(entity_id, topic_id) do
    %EntityTopic{}
    |> EntityTopic.changeset(%{entity_id: entity_id, topic_id: topic_id})
    |> Repo.insert()
  end

  def add_tags(content, tags) when is_binary(tags) do
    Enum.each(split_tags(tags), &add_tag(content, &1))
    content
  end

  def add_tags(content, tags) do
    Enum.each(tags, &add_tag(content, &1))
    content
  end

  def remove_tag(content, topic_text) when is_binary(topic_text) do
    case Repo.get_by(Topic, %{text: topic_text}) do
      nil -> nil
      topic -> remove_tag(content, topic.id)
    end
  end

  def remove_tag(%{entity_id: entity_id}, topic_id) do
    remove_tag(entity_id, topic_id)
  end

  def remove_tag(%Entity{} = entity, topic_id) do
    remove_tag(entity.id, topic_id)
  end

  def remove_tag(entity_id, topic_id) do
    case Repo.get_by(EntityTopic, %{entity_id: entity_id, topic_id: topic_id}) do
      nil -> nil
      tag -> Repo.delete(tag)
    end
  end

  def remove_tags(content, tags) when is_binary(tags) do
    Enum.each(split_tags(tags), &remove_tag(content, &1))
    content
  end

  def remove_tags(content, tags) do
    Enum.each(tags, &remove_tag(content, &1))
    content
  end

  def tags_loaded(%{entity: %{topics: topics}}) do
    topics |> Enum.map_join(", ", & &1.text)
  end

  def split_tags(tags_string) when is_binary(tags_string) do
    tags_string |> String.split(",") |> Enum.map(&String.trim/1)
  end

  def update_tags(content, new_tags) when is_binary(new_tags) do
    old_tags = tags_loaded(content) |> split_tags()
    new_tags = new_tags |> split_tags()

    content
    |> add_tags(new_tags -- old_tags)
    |> remove_tags(old_tags -- new_tags)
  end

  # Utils

  def list(schema, constraint, limit \\ 12) do
    schema
    |> order_by(^constraint)
    |> limit(^limit)
    |> Repo.all()
    |> Repo.preload(entity: [:topics, :images])
  end
end
