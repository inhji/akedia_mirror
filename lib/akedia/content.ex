defmodule Akedia.Content do
  import Ecto.Query, warn: false
  alias Akedia.Repo
  alias Akedia.Content.{Entity, Page, Story, Bookmark, Topic, EntityTopic}

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
    Repo.transaction(fn ->
      {:ok, entity} = create_entity()

      changeset =
        %Story{}
        |> Story.changeset(Map.put(attrs, "entity_id", entity.id))

      case Repo.insert(changeset) do
        {:ok, story} -> story
        {:error, changeset} -> Repo.rollback(changeset)
      end
    end)
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
    Repo.transaction(fn ->
      {:ok, entity} = create_entity()

      changeset =
        %Page{}
        |> Page.changeset(Map.put(attrs, "entity_id", entity.id))

      case Repo.insert(changeset) do
        {:ok, page} -> page
        {:error, changeset} -> Repo.rollback(changeset)
      end
    end)
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

  # Bookmark

  def list_bookmarks do
    list(Bookmark)
  end

  def list_published_bookmarks do
    list_published(Bookmark)
  end

  def get_bookmark!(id) do
    Bookmark
    |> Repo.get_by!(slug: id)
    |> Repo.preload(entity: [:topics, :images])
  end

  def create_bookmark(attrs \\ %{}, is_published \\ true) do
    Repo.transaction(fn ->
      {:ok, entity} = create_entity(%{is_published: is_published})

      changeset =
        %Bookmark{}
        |> Bookmark.changeset(Map.put(attrs, "entity_id", entity.id))

      case Repo.insert(changeset) do
        {:ok, bookmark} -> bookmark
        {:error, changeset} -> Repo.rollback(changeset)
      end
    end)
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

  # Topic

  def list_topics do
    Topic
    |> Repo.all()
    |> Repo.preload(entities: [:bookmark, :story, :page])
  end

  def get_topic!(id) do
    Topic
    |> Repo.get_by!(text: id)
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

  # Tag Utils

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
        (unquote(content)),
        (unquote(search_term))
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

  alias Akedia.Content.Like

  @doc """
  Returns the list of likes.

  ## Examples

      iex> list_likes()
      [%Like{}, ...]

  """
  def list_likes do
    Repo.all(Like)
  end

  @doc """
  Gets a single like.

  Raises `Ecto.NoResultsError` if the Like does not exist.

  ## Examples

      iex> get_like!(123)
      %Like{}

      iex> get_like!(456)
      ** (Ecto.NoResultsError)

  """
  def get_like!(id), do: Repo.get!(Like, id)

  @doc """
  Creates a like.

  ## Examples

      iex> create_like(%{field: value})
      {:ok, %Like{}}

      iex> create_like(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_like(attrs \\ %{}) do
    %Like{}
    |> Like.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a like.

  ## Examples

      iex> update_like(like, %{field: new_value})
      {:ok, %Like{}}

      iex> update_like(like, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_like(%Like{} = like, attrs) do
    like
    |> Like.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Like.

  ## Examples

      iex> delete_like(like)
      {:ok, %Like{}}

      iex> delete_like(like)
      {:error, %Ecto.Changeset{}}

  """
  def delete_like(%Like{} = like) do
    Repo.delete(like)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking like changes.

  ## Examples

      iex> change_like(like)
      %Ecto.Changeset{source: %Like{}}

  """
  def change_like(%Like{} = like) do
    Like.changeset(like, %{})
  end
end
