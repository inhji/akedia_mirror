defmodule Akedia.Content do
  import Ecto.Query, warn: false
  alias Akedia.Repo
  alias Akedia.Content.{Entity, Page, Story, Bookmark, Topic, EntityTopic, Like, Post}

  # Entity

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

  # Story

  def list_stories do
    list(Story)
  end

  def list_published_stories() do
    list_published(Story)
  end

  def get_story!(id) do
    Story
    |> Repo.get_by!(slug: id)
    |> Repo.preload(entity: [:topics, :images])
  end

  def create_story(attrs \\ %{}) do
    create_with_entity(Story, attrs)
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
    {:ok, story}
  end

  def change_story(%Story{} = story) do
    Story.changeset(story, %{})
  end

  # Page

  def list_pages do
    list(Page)
  end

  def list_published_pages() do
    list_published(Page)
  end

  def get_page!(id) do
    Page
    |> Repo.get_by!(slug: id)
    |> Repo.preload(entity: [:topics, :images])
  end

  def create_page(attrs \\ %{}) do
    create_with_entity(Page, attrs)
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
    {:ok, page}
  end

  def change_page(%Page{} = page) do
    Page.changeset(page, %{})
  end

  # Bookmark

  def list_bookmarks do
    Bookmark
    |> list()
    |> Repo.preload(:favicon)
  end

  def list_published_bookmarks do
    Bookmark
    |> list_published()
    |> Repo.preload(:favicon)
  end

  def get_bookmark!(id) do
    Bookmark
    |> Repo.get_by!(slug: id)
    |> Repo.preload(entity: [:topics, :images])
    |> Repo.preload(:favicon)
  end

  def create_bookmark(attrs \\ %{}, is_published \\ true) do
    create_with_entity(Bookmark, attrs, %{is_published: is_published})
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
    {:ok, bookmark}
  end

  def change_bookmark(%Bookmark{} = bookmark) do
    Bookmark.changeset(bookmark, %{})
  end

  # Like

  def list_likes do
    Repo.all(Like)
  end

  def get_like!(id) do
    Like
    |> Repo.get!(id)
    |> Repo.preload(entity: [:topics, :images])
  end

  def create_like(attrs \\ %{}, is_published \\ false) do
    create_with_entity(Like, attrs, %{is_published: is_published})
  end

  def update_like(%Like{} = like, attrs) do
    like
    |> Like.changeset(attrs)
    |> Repo.update()
  end

  def delete_like(%Like{} = like) do
    Repo.delete(like)
  end

  def change_like(%Like{} = like) do
    Like.changeset(like, %{})
  end

  # Topic

  def list_topics do
    Topic
    |> order_by(:slug)
    |> Repo.all()
    |> Repo.preload(entities: [:bookmark, :story, :page, :post, :like])
  end

  def get_topic!(id) do
    Topic
    |> Repo.get_by!(slug: id)
    |> Repo.preload(entities: [:bookmark, :story, :page, :post, :like])
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

  # Post

  def list_posts do
    list(Post)
  end

  def get_post!(id) do
    Post
    |> Repo.get_by!(slug: id)
    |> Repo.preload(entity: [:topics, :images])
  end

  def create_post(attrs \\ %{}, is_published \\ true) do
    create_with_entity(Post, attrs, %{is_published: is_published})
  end

  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  def change_post(%Post{} = post) do
    Post.changeset(post, %{})
  end

  # Tag Utils

  def add_tag(entity, topic_text) when is_binary(topic_text) do
    slug =
      topic_text
      |> Slugger.slugify()
      |> String.downcase()

    topic =
      case Repo.get_by(Topic, %{slug: slug}) do
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
    tags_string
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(&(String.length(&1) > 0))
  end

  def update_tags(content, new_tags) when is_binary(new_tags) do
    old_tags = tags_loaded(content) |> split_tags()
    new_tags = new_tags |> split_tags()

    content
    |> add_tags(new_tags -- old_tags)
    |> remove_tags(old_tags -- new_tags)
  end

  # Query Utils

  def search(search_term) do
    search_query(search_term)
    |> Repo.all()
  end

  defmacro contains(content, search_term) do
    quote do
      fragment(
        "? %> ?",
        unquote(content),
        unquote(search_term)
      )
    end
  end

  def search_query(search_term) do
    from e in Entity,
      left_join: b in assoc(e, :bookmark),
      on: e.id == b.entity_id,
      left_join: p in assoc(e, :page),
      on: e.id == p.entity_id,
      left_join: s in assoc(e, :story),
      on: e.id == s.entity_id,
      left_join: t in assoc(e, :topics),
      where: contains(b.title, ^search_term),
      or_where: contains(b.content, ^search_term),
      or_where: contains(p.title, ^search_term),
      or_where: contains(p.content, ^search_term),
      or_where: contains(s.title, ^search_term),
      or_where: contains(s.content, ^search_term),
      or_where: t.text in [^search_term],
      distinct: true,
      preload: [:bookmark, :page, :story, :topics]
  end

  def list(schema, constraint \\ [desc: :inserted_at]) do
    schema
    |> order_by(^constraint)
    |> Repo.all()
    |> Repo.preload(entity: [:topics, :images])
  end

  def list_published(schema, constraint \\ [desc: :inserted_at]) do
    # This seems utterly complicated but okay for now
    # join is needed to show just published entities
    # group_by is needed to remove duplicate items from joined query
    schema
    |> join(:left, [s], e in Entity, on: e.is_published == true)
    |> group_by([s], [s.id, s.entity_id])
    |> order_by(^constraint)
    |> Repo.all()
    |> Repo.preload(entity: [:topics, :images])
  end

  def create_with_entity(schema, attrs \\ %{}) do
    create_with_entity(schema, attrs, %{is_published: false})
  end

  def create_with_entity(schema, attrs, entity_attrs) do
    Repo.transaction(fn ->
      {:ok, entity} = create_entity(entity_attrs)

      schema_attrs =
        attrs
        |> key_to_atom()
        |> Map.put(:entity_id, entity.id)

      changeset =
        schema
        |> Kernel.struct()
        |> schema.changeset(schema_attrs)

      case Repo.insert(changeset) do
        {:ok, item} -> item
        {:error, changeset} -> Repo.rollback(changeset)
      end
    end)
  end

  def key_to_atom(map) do
    Enum.reduce(map, %{}, fn
      {key, value}, acc when is_atom(key) -> Map.put(acc, key, value)
      # String.to_existing_atom saves us from overloading the VM by
      # creating too many atoms. It'll always succeed because all the fields
      # in the database already exist as atoms at runtime.
      {key, value}, acc when is_binary(key) -> Map.put(acc, String.to_existing_atom(key), value)
    end)
  end
end
