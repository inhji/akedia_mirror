defmodule Akedia.Content do
  import Ecto.Query, warn: false
  alias Akedia.Repo

  alias Akedia.Content.{
    Entity,
    Page,
    Bookmark,
    Topic,
    EntityTopic,
    Like,
    Post,
    Syndication
  }

  @preloads [entity: [:topics, :image, :syndications, mentions: [:author]]]

  # Entity

  def list_entities(limit \\ 10) do
    entity_query()
    |> limit(^limit)
    |> Repo.all()
  end

  def list_entities_paginated(params \\ %{}) do
    query = entity_query()
    Repo.paginate(query, params)
  end

  def list_pinned_entities() do
    query =
      from entity in entity_query(),
        where: [is_pinned: true]

    Repo.all(query)
  end

  def entity_query() do
    from entity in Entity,
      left_join: like in Like,
      on: entity.id == like.entity_id,
      left_join: post in Post,
      on: entity.id == post.entity_id,
      left_join: bookmark in Bookmark,
      on: entity.id == bookmark.entity_id,
      order_by: [desc: :inserted_at],
      preload: [
        :image,
        like: ^@preloads,
        post: ^@preloads,
        bookmark: [:favicon, ^@preloads]
      ],
      where: not is_nil(like.id),
      or_where: not is_nil(post.id),
      or_where: not is_nil(bookmark.id),
      where: [is_published: true],
      select: entity
  end

  def get_entity!(id) do
    Entity
    |> Repo.get!(id)
    |> Repo.preload([:bookmark, :page, :like, :post])
  end

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

  # Page

  def list_pages(opts \\ []) do
    list_query(Page, opts)
    |> where([p], p.title != "Home")
    |> Repo.all()
    |> Repo.preload(entity: [:topics, :image, :syndications])
  end

  def get_page!(id) do
    Page
    |> Repo.get_by!(slug: id)
    |> Repo.preload(@preloads)
  end

  def get_home_page() do
    Page
    |> Repo.get_by(title: "Home")
    |> Repo.preload(@preloads)
  end

  def create_page(attrs \\ %{}),
    do: create_with_entity(Page, attrs)

  def create_page(attrs, entity_attrs),
    do: create_with_entity(Page, attrs, entity_attrs)

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

  def list_bookmarks(opts \\ []) do
    Bookmark
    |> list(opts)
    |> Repo.preload(:favicon)
  end

  def get_bookmark!(id) do
    Bookmark
    |> Repo.get_by!(slug: id)
    |> Repo.preload(@preloads)
    |> Repo.preload(:favicon)
  end

  def create_bookmark(attrs \\ %{}, entity_attrs \\ %{is_published: true}) do
    create_with_entity(Bookmark, attrs, entity_attrs)
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

  def list_likes(opts \\ []) do
    list(Like, opts)
  end

  def get_like!(id) do
    Like
    |> Repo.get!(id)
    |> Repo.preload(@preloads)
  end

  def create_like(attrs \\ %{}, entity_attrs \\ %{is_published: true}) do
    create_with_entity(Like, attrs, entity_attrs)
  end

  def update_like(%Like{} = like, attrs) do
    like
    |> Like.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:entity, with: &Entity.changeset/2)
    |> Repo.update()
  end

  def delete_like(%Like{} = like) do
    Repo.delete(like)
  end

  def change_like(%Like{} = like) do
    Like.changeset(like, %{})
  end

  # Topic

  def list_topics() do
    list_topics_query()
    |> Repo.all()
    |> Repo.preload(entities: [:bookmark, :page, :post, :like])
  end

  def list_top_topics(limit) do
    list_top_topics_query()
    |> limit(^limit)
    |> Repo.all()
    |> Repo.preload(entities: [:bookmark, :page, :post, :like])
  end

  def list_topics_query() do
    Topic
    |> join(:left, [t], et in EntityTopic, on: t.id == et.topic_id)
    |> group_by([t], t.id)
    |> order_by([t, et], asc: t.text)
    |> select_merge([t, et], %{entity_count: count(et.id)})
  end

  def list_top_topics_query() do
    Topic
    |> join(:left, [t], et in EntityTopic, on: t.id == et.topic_id)
    |> group_by([t], t.id)
    |> order_by([t, et], desc: count(et.id))
    |> select_merge([t, et], %{entity_count: count(et.id)})
  end

  def get_topic!(id) do
    Topic
    |> Repo.get_by!(slug: id)
    |> Repo.preload(
      entities: [
        like: [entity: [:topics, :syndications, :image]],
        post: [entity: [:topics, :syndications, :image]],
        bookmark: [:favicon, entity: [:topics, :syndications, :image]]
      ]
    )
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

  def list_posts(opts \\ []) do
    list(Post, opts)
  end

  def list_posts_paginated(opts \\ [], params \\ %{}) do
    list_query(Post, opts)
    |> preload(entity: [:topics, :image, :syndications])
    |> Repo.paginate(params)
  end

  def get_post!(id) do
    Post
    |> Repo.get_by!(slug: id)
    |> Repo.preload(@preloads)
  end

  def get_latest_post() do
    Post
    |> order_by(desc: :inserted_at)
    |> limit(1)
    |> Repo.one!()
    |> Repo.preload(@preloads)
  end

  def create_post(attrs \\ %{}, entity_attrs \\ %{is_published: true}) do
    create_with_entity(Post, attrs, entity_attrs)
  end

  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:entity, with: &Entity.changeset/2)
    |> Repo.update()
  end

  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  def change_post(%Post{} = post) do
    Post.changeset(post, %{})
  end

  # Syndication

  def list_syndications do
    Repo.all(Syndication)
  end

  def get_syndication!(id), do: Repo.get!(Syndication, id)

  def get_syndication_by_type(entity_id, type) do
    Repo.get_by(Syndication, entity_id: entity_id, type: type)
  end

  def create_or_update_syndication(attrs \\ %{}) do
    case get_syndication_by_type(attrs[:entity_id], attrs[:type]) do
      nil -> create_syndication(attrs)
      syndication -> update_syndication(syndication, attrs)
    end
  end

  def create_syndication(attrs \\ %{}) do
    %Syndication{}
    |> Syndication.changeset(attrs)
    |> Repo.insert()
  end

  def update_syndication(%Syndication{} = syndication, attrs) do
    syndication
    |> Syndication.changeset(attrs)
    |> Repo.update()
  end

  def delete_syndication(%Syndication{} = syndication) do
    Repo.delete(syndication)
  end

  def change_syndication(%Syndication{} = syndication) do
    Syndication.changeset(syndication, %{})
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
    search_term = String.downcase(search_term)

    from e in Entity,
      left_join: b in assoc(e, :bookmark),
      on: e.id == b.entity_id,
      left_join: pp in assoc(e, :post),
      on: e.id == pp.entity_id,
      left_join: l in assoc(e, :like),
      on: e.id == l.entity_id,
      left_join: t in assoc(e, :topics),
      where: contains(b.title, ^search_term),
      or_where: contains(b.content, ^search_term),
      or_where: contains(pp.title, ^search_term),
      or_where: contains(pp.content, ^search_term),
      or_where: contains(l.url, ^search_term),
      or_where: contains(t.text, ^search_term),
      distinct: true,
      order_by: [desc: :inserted_at],
      preload: [
        like: ^@preloads,
        post: ^@preloads,
        bookmark: [:favicon, ^@preloads]
      ]
  end

  def list(schema, options \\ []) do
    schema
    |> list_query(options)
    |> Repo.all()
    |> Repo.preload(entity: [:topics, :image, :syndications])
  end

  def list_query(schema, options \\ []) do
    sort_options = options[:order_by] || [desc: :inserted_at]
    limit_options = options[:limit] || nil

    schema
    |> join(:inner, [s], e in Entity, on: s.entity_id == e.id)
    |> maybe_where(options, [:is_published, :is_pinned])
    |> maybe_limit(limit_options)
    |> order_by(^sort_options)
  end

  def maybe_where(query, options, valid_options) do
    Enum.reduce(valid_options, query, fn p, q ->
      if !is_nil(options[p]) and is_boolean(options[p]),
        do: where(q, [_s, e], field(e, ^p) == ^options[p]),
        else: q
    end)
  end

  def maybe_limit(query, nil), do: query

  def maybe_limit(query, limit) do
    query
    |> limit(^limit)
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
