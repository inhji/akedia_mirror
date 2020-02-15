defmodule Akedia.Content do
  @moduledoc """
  Content context, contains the following models:

  * `Akedia.Content.Entity`
  * `Akedia.Content.Bookmark`
  * `Akedia.Content.Topic`
  * `Akedia.Content.Like`
  * `Akedia.Content.Post`
  * `Akedia.Content.Syndication`
  """
  import Ecto.Query, warn: false
  alias Akedia.Repo

  alias Akedia.Content.{
    Entity,
    Bookmark,
    Topic,
    EntityTopic,
    Like,
    Post,
    Syndication
  }

  @preloads [entity: [:topics, :image, :syndications, mentions: [:author], context: [:author]]]

  # $$$$$$$$\            $$\     $$\   $$\               
  # $$  _____|           $$ |    \__|  $$ |              
  # $$ |      $$$$$$$\ $$$$$$\   $$\ $$$$$$\   $$\   $$\ 
  # $$$$$\    $$  __$$\\_$$  _|  $$ |\_$$  _|  $$ |  $$ |
  # $$  __|   $$ |  $$ | $$ |    $$ |  $$ |    $$ |  $$ |
  # $$ |      $$ |  $$ | $$ |$$\ $$ |  $$ |$$\ $$ |  $$ |
  # $$$$$$$$\ $$ |  $$ | \$$$$  |$$ |  \$$$$  |\$$$$$$$ |
  # \________|\__|  \__|  \____/ \__|   \____/  \____$$ |
  #                                            $$\   $$ |
  #                                            \$$$$$$  |
  #                                             \______/ 

  @doc model: :entity
  def list_entities(limit \\ 10) do
    entity_query()
    |> limit(^limit)
    |> Repo.all()
  end

  @doc model: :entity
  def list_entities_paginated(%{"type" => type} = params) do
    query =
      from entity in entity_query(),
        where: [is_published: true]

    query
    |> filter_entity_query(type)
    |> Repo.paginate(params)
  end

  @doc model: :entity
  def list_entities_paginated(params) do
    query =
      from entity in entity_query(),
        where: [is_published: true],
        preload: [context: [:author]]

    Repo.paginate(query, params)
  end

  @doc model: :entity
  def filter_entity_query(query, "post") do
    where(query, [e, l, p, b], not is_nil(p.id))
  end

  @doc model: :entity
  def filter_entity_query(query, "like") do
    where(query, [e, l, p, b], not is_nil(l.id))
  end

  @doc model: :entity
  def filter_entity_query(query, "bookmark") do
    where(query, [e, l, p, b], not is_nil(b.id))
  end

  @doc model: :entity
  def filter_entity_query(query, _) do
    query
    |> where([e, l, p, b], not is_nil(p.id))
    |> or_where([e, l, p, b], not is_nil(l.id))
    |> or_where([e, l, p, b], not is_nil(b.id))
  end

  @doc model: :entity
  def list_pinned_entities() do
    Repo.all(
      from entity in entity_query(),
        where: [is_pinned: true, is_published: true]
    )
  end

  @doc model: :entity
  def list_queued_entities() do
    Repo.all(
      from entity in entity_query(),
        where: [is_published: false]
    )
  end

  @doc model: :entity
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
      select: entity
  end

  @doc model: :entity
  def get_entity!(id) do
    Entity
    |> Repo.get!(id)
    |> Repo.preload([:bookmark, :like, :post])
  end

  @doc model: :entity
  def create_entity(attrs \\ %{}) do
    %Entity{}
    |> Entity.changeset(attrs)
    |> Repo.insert()
  end

  @doc model: :entity
  def update_entity(%Entity{} = entity, attrs) do
    entity
    |> Entity.changeset(attrs)
    |> Repo.update()
  end

  @doc model: :entity
  def delete_entity(entity_id) when is_integer(entity_id) do
    entity = Repo.get!(Entity, entity_id)
    delete_entity(entity)
  end

  @doc model: :entity
  def delete_entity(%Entity{} = entity) do
    Repo.delete(entity)
  end

  @doc model: :entity
  def change_entity(%Entity{} = entity) do
    Entity.changeset(entity, %{})
  end

  # $$$$$$$\                      $$\                                         $$\       
  # $$  __$$\                     $$ |                                        $$ |      
  # $$ |  $$ | $$$$$$\   $$$$$$\  $$ |  $$\ $$$$$$\$$$$\   $$$$$$\   $$$$$$\  $$ |  $$\ 
  # $$$$$$$\ |$$  __$$\ $$  __$$\ $$ | $$  |$$  _$$  _$$\  \____$$\ $$  __$$\ $$ | $$  |
  # $$  __$$\ $$ /  $$ |$$ /  $$ |$$$$$$  / $$ / $$ / $$ | $$$$$$$ |$$ |  \__|$$$$$$  / 
  # $$ |  $$ |$$ |  $$ |$$ |  $$ |$$  _$$<  $$ | $$ | $$ |$$  __$$ |$$ |      $$  _$$<  
  # $$$$$$$  |\$$$$$$  |\$$$$$$  |$$ | \$$\ $$ | $$ | $$ |\$$$$$$$ |$$ |      $$ | \$$\ 
  # \_______/  \______/  \______/ \__|  \__|\__| \__| \__| \_______|\__|      \__|  \__|                                                                             

  @doc model: :bookmark
  def list_bookmarks(opts \\ []) do
    Bookmark
    |> list(opts)
    |> Repo.preload(:favicon)
  end

  @doc model: :bookmark
  def get_bookmark!(id) do
    Bookmark
    |> Repo.get_by!(slug: id)
    |> Repo.preload(@preloads)
    |> Repo.preload(:favicon)
  end

  @doc model: :bookmark
  def create_bookmark(attrs) do
    create_with_entity(Bookmark, attrs)
  end

  @doc model: :bookmark
  def create_bookmark(attrs, entity_attrs) do
    create_with_entity(Bookmark, attrs, entity_attrs)
  end

  @doc model: :bookmark
  def update_bookmark(%Bookmark{} = bookmark, attrs) do
    bookmark
    |> Bookmark.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:entity, with: &Entity.changeset/2)
    |> Repo.update()
  end

  @doc model: :bookmark
  def delete_bookmark(%Bookmark{} = bookmark) do
    Repo.delete(bookmark)
    delete_entity(bookmark.entity_id)
    {:ok, bookmark}
  end

  @doc model: :bookmark
  def change_bookmark(%Bookmark{} = bookmark) do
    Bookmark.changeset(bookmark, %{})
  end

  # $$\       $$\ $$\                 
  # $$ |      \__|$$ |                
  # $$ |      $$\ $$ |  $$\  $$$$$$\  
  # $$ |      $$ |$$ | $$  |$$  __$$\ 
  # $$ |      $$ |$$$$$$  / $$$$$$$$ |
  # $$ |      $$ |$$  _$$<  $$   ____|
  # $$$$$$$$\ $$ |$$ | \$$\ \$$$$$$$\ 
  # \________|\__|\__|  \__| \_______|

  @doc model: :like
  def list_likes(opts \\ []) do
    list(Like, opts)
  end

  @doc model: :like
  def get_like!(id) do
    Like
    |> Repo.get!(id)
    |> Repo.preload(@preloads)
  end

  @doc model: :like
  def create_like(attrs) do
    create_with_entity(Like, attrs)
  end

  @doc model: :like
  def create_like(attrs, entity_attrs) do
    create_with_entity(Like, attrs, entity_attrs)
  end

  @doc model: :like
  def update_like(%Like{} = like, attrs) do
    like
    |> Like.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:entity, with: &Entity.changeset/2)
    |> Repo.update()
  end

  @doc model: :like
  def delete_like(%Like{} = like) do
    Repo.delete(like)
  end

  @doc model: :like
  def change_like(%Like{} = like) do
    Like.changeset(like, %{})
  end

  # $$$$$$$$\                  $$\           
  # \__$$  __|                 \__|          
  #    $$ | $$$$$$\   $$$$$$\  $$\  $$$$$$$\ 
  #    $$ |$$  __$$\ $$  __$$\ $$ |$$  _____|
  #    $$ |$$ /  $$ |$$ /  $$ |$$ |$$ /      
  #    $$ |$$ |  $$ |$$ |  $$ |$$ |$$ |      
  #    $$ |\$$$$$$  |$$$$$$$  |$$ |\$$$$$$$\ 
  #    \__| \______/ $$  ____/ \__| \_______|
  #                  $$ |                    
  #                  $$ |                    
  #                  \__|                    

  @doc model: :topic
  def list_topics() do
    list_topics_query()
    |> Repo.all()
    |> Repo.preload(entities: [:bookmark, :post, :like])
  end

  @doc model: :topic
  def list_pinned_topics() do
    list_top_topics_query()
    |> where([t, et], t.is_pinned == true)
    |> Repo.all()
    |> Repo.preload(entities: [:bookmark, :post, :like])
  end

  @doc model: :topic
  def list_top_topics(limit) do
    list_top_topics_query()
    |> limit(^limit)
    |> Repo.all()
    |> Repo.preload(entities: [:bookmark, :post, :like])
  end

  @doc model: :topic
  def list_topics_query() do
    Topic
    |> join(:left, [t], et in EntityTopic, on: t.id == et.topic_id)
    |> group_by([t], t.id)
    |> order_by([t, et], asc: t.text)
    |> select_merge([t, et], %{entity_count: count(et.id)})
  end

  @doc model: :topic
  def list_top_topics_query() do
    Topic
    |> join(:left, [t], et in EntityTopic, on: t.id == et.topic_id)
    |> group_by([t], t.id)
    |> order_by([t, et], desc: count(et.id))
    |> select_merge([t, et], %{entity_count: count(et.id)})
  end

  @doc model: :topic
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

  @doc model: :topic
  def create_topic(attrs \\ %{}) do
    %Topic{}
    |> Topic.changeset(attrs)
    |> Repo.insert()
  end

  @doc model: :topic
  def update_topic(%Topic{} = topic, attrs) do
    topic
    |> Topic.changeset(attrs)
    |> Repo.update()
  end

  @doc model: :topic
  def delete_topic(%Topic{} = topic) do
    Repo.delete(topic)
  end

  @doc model: :topic
  def change_topic(%Topic{} = topic) do
    Topic.changeset(topic, %{})
  end

  # $$$$$$$\                        $$\     
  # $$  __$$\                       $$ |    
  # $$ |  $$ | $$$$$$\   $$$$$$$\ $$$$$$\   
  # $$$$$$$  |$$  __$$\ $$  _____|\_$$  _|  
  # $$  ____/ $$ /  $$ |\$$$$$$\    $$ |    
  # $$ |      $$ |  $$ | \____$$\   $$ |$$\ 
  # $$ |      \$$$$$$  |$$$$$$$  |  \$$$$  |
  # \__|       \______/ \_______/    \____/ 

  @doc model: :post
  def list_posts(opts \\ []) do
    list(Post, opts)
  end

  @doc model: :post
  def list_posts_paginated(opts \\ [], params \\ %{}) do
    list_query(Post, opts)
    |> preload(entity: [:topics, :image, :syndications])
    |> Repo.paginate(params)
  end

  @doc model: :post
  def get_post!(id) do
    Post
    |> Repo.get_by!(slug: id)
    |> Repo.preload(@preloads)
  end

  @doc model: :post
  def get_latest_post() do
    Post
    |> order_by(desc: :inserted_at)
    |> limit(1)
    |> Repo.one!()
    |> Repo.preload(@preloads)
  end

  @doc model: :post
  def create_post(attrs) do
    create_with_entity(Post, attrs)
  end

  @doc model: :post
  def create_post(attrs, entity_attrs) do
    create_with_entity(Post, attrs, entity_attrs)
  end

  @doc model: :post
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Ecto.Changeset.cast_assoc(:entity, with: &Entity.changeset/2)
    |> Repo.update()
  end

  @doc model: :post
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc model: :post
  def change_post(%Post{} = post) do
    Post.changeset(post, %{})
  end

  #  $$$$$$\                            $$\ $$\                     $$\     $$\                     
  # $$  __$$\                           $$ |\__|                    $$ |    \__|                    
  # $$ /  \__|$$\   $$\ $$$$$$$\   $$$$$$$ |$$\  $$$$$$$\ $$$$$$\ $$$$$$\   $$\  $$$$$$\  $$$$$$$\  
  # \$$$$$$\  $$ |  $$ |$$  __$$\ $$  __$$ |$$ |$$  _____|\____$$\\_$$  _|  $$ |$$  __$$\ $$  __$$\ 
  #  \____$$\ $$ |  $$ |$$ |  $$ |$$ /  $$ |$$ |$$ /      $$$$$$$ | $$ |    $$ |$$ /  $$ |$$ |  $$ |
  # $$\   $$ |$$ |  $$ |$$ |  $$ |$$ |  $$ |$$ |$$ |     $$  __$$ | $$ |$$\ $$ |$$ |  $$ |$$ |  $$ |
  # \$$$$$$  |\$$$$$$$ |$$ |  $$ |\$$$$$$$ |$$ |\$$$$$$$\\$$$$$$$ | \$$$$  |$$ |\$$$$$$  |$$ |  $$ |
  #  \______/  \____$$ |\__|  \__| \_______|\__| \_______|\_______|  \____/ \__| \______/ \__|  \__|
  #           $$\   $$ |                                                                            
  #           \$$$$$$  |                                                                            
  #            \______/                                                                             

  @doc model: :syndication
  def list_syndications do
    Repo.all(Syndication)
  end

  @doc model: :syndication
  def get_syndication!(id), do: Repo.get!(Syndication, id)

  @doc model: :syndication
  def get_syndication_by_type(entity_id, type) do
    Repo.get_by(Syndication, entity_id: entity_id, type: type)
  end

  @doc model: :syndication
  def create_or_update_syndication(attrs \\ %{}) do
    case get_syndication_by_type(attrs[:entity_id], attrs[:type]) do
      nil -> create_syndication(attrs)
      syndication -> update_syndication(syndication, attrs)
    end
  end

  @doc model: :syndication
  def create_syndication(attrs \\ %{}) do
    %Syndication{}
    |> Syndication.changeset(attrs)
    |> Repo.insert()
  end

  @doc model: :syndication
  def update_syndication(%Syndication{} = syndication, attrs) do
    syndication
    |> Syndication.changeset(attrs)
    |> Repo.update()
  end

  @doc model: :syndication
  def delete_syndication(%Syndication{} = syndication) do
    Repo.delete(syndication)
  end

  @doc model: :syndication
  def change_syndication(%Syndication{} = syndication) do
    Syndication.changeset(syndication, %{})
  end

  # $$$$$$$$\                            
  # \__$$  __|                           
  #    $$ | $$$$$$\   $$$$$$\   $$$$$$$\ 
  #    $$ | \____$$\ $$  __$$\ $$  _____|
  #    $$ | $$$$$$$ |$$ /  $$ |\$$$$$$\  
  #    $$ |$$  __$$ |$$ |  $$ | \____$$\ 
  #    $$ |\$$$$$$$ |\$$$$$$$ |$$$$$$$  |
  #    \__| \_______| \____$$ |\_______/ 
  #                  $$\   $$ |          
  #                  \$$$$$$  |          
  #                   \______/           

  @doc utils: :tag
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

  @doc utils: :tag
  def add_tag(%{entity_id: entity_id}, topic_id) do
    add_tag(entity_id, topic_id)
  end

  @doc utils: :tag
  def add_tag(%Entity{} = entity, topic_id) do
    add_tag(entity.id, topic_id)
  end

  @doc utils: :tag
  def add_tag(entity_id, topic_id) do
    %EntityTopic{}
    |> EntityTopic.changeset(%{entity_id: entity_id, topic_id: topic_id})
    |> Repo.insert()
  end

  @doc utils: :tag
  def add_tags(content, tags) when is_binary(tags) do
    Enum.each(split_tags(tags), &add_tag(content, &1))
    content
  end

  @doc utils: :tag
  def add_tags(content, tags) do
    Enum.each(tags, &add_tag(content, &1))
    content
  end

  @doc utils: :tag
  def remove_tag(content, topic_text) when is_binary(topic_text) do
    case Repo.get_by(Topic, %{text: topic_text}) do
      nil -> nil
      topic -> remove_tag(content, topic.id)
    end
  end

  @doc utils: :tag
  def remove_tag(%{entity_id: entity_id}, topic_id) do
    remove_tag(entity_id, topic_id)
  end

  @doc utils: :tag
  def remove_tag(%Entity{} = entity, topic_id) do
    remove_tag(entity.id, topic_id)
  end

  @doc utils: :tag
  def remove_tag(entity_id, topic_id) do
    case Repo.get_by(EntityTopic, %{entity_id: entity_id, topic_id: topic_id}) do
      nil -> nil
      tag -> Repo.delete(tag)
    end
  end

  @doc utils: :tag
  def remove_tags(content, tags) when is_binary(tags) do
    Enum.each(split_tags(tags), &remove_tag(content, &1))
    content
  end

  @doc utils: :tag
  def remove_tags(content, tags) do
    Enum.each(tags, &remove_tag(content, &1))
    content
  end

  @doc utils: :tag
  def tags_loaded(%{entity: %{topics: topics}}) do
    topics |> Enum.map_join(", ", & &1.text)
  end

  @doc utils: :tag
  def split_tags(tags_string) when is_binary(tags_string) do
    tags_string
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.filter(&(String.length(&1) > 0))
  end

  @doc utils: :tag
  def update_tags(content, new_tags) when is_binary(new_tags) do
    old_tags = tags_loaded(content) |> split_tags()
    new_tags = new_tags |> split_tags()

    content
    |> add_tags(new_tags -- old_tags)
    |> remove_tags(old_tags -- new_tags)
  end

  #  $$$$$$\                                          
  # $$  __$$\                                         
  # $$ /  $$ |$$\   $$\  $$$$$$\   $$$$$$\  $$\   $$\ 
  # $$ |  $$ |$$ |  $$ |$$  __$$\ $$  __$$\ $$ |  $$ |
  # $$ |  $$ |$$ |  $$ |$$$$$$$$ |$$ |  \__|$$ |  $$ |
  # $$ $$\$$ |$$ |  $$ |$$   ____|$$ |      $$ |  $$ |
  # \$$$$$$ / \$$$$$$  |\$$$$$$$\ $$ |      \$$$$$$$ |
  #  \___$$$\  \______/  \_______|\__|       \____$$ |
  #      \___|                              $$\   $$ |
  #                                         \$$$$$$  |
  #                                          \______/ 

  @doc utils: :query
  def schema_per_month(schema) do
    schema
    |> select([l], [count(l.id), fragment("date_trunc('month', ?) as month", l.inserted_at)])
    |> group_by([l], fragment("month"))
    |> order_by([l], fragment("month"))
    |> Repo.all()
  end

  @doc utils: :query
  def schema_per_week(schema) do
    schema
    |> select([l], [count(l.id), fragment("date_trunc('week', ?) as week", l.inserted_at)])
    |> group_by([l], fragment("week"))
    |> order_by([l], fragment("week"))
    |> Repo.all()
  end

  @doc utils: :query
  def search(search_term) do
    search_query(search_term)
    |> Repo.all()
  end

  @doc utils: :query
  defmacro contains(content, search_term) do
    quote do
      fragment(
        "? %> ?",
        unquote(content),
        unquote(search_term)
      )
    end
  end

  @doc utils: :query
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

  @doc utils: :query
  def list(schema, options \\ []) do
    schema
    |> list_query(options)
    |> Repo.all()
    |> Repo.preload(entity: [:topics, :image, :syndications])
  end

  @doc utils: :query
  def list_query(schema, options \\ []) do
    sort_options = options[:order_by] || [desc: :inserted_at]
    limit_options = options[:limit] || nil

    schema
    |> join(:inner, [s], e in Entity, on: s.entity_id == e.id)
    |> maybe_where(options, [:is_published, :is_pinned])
    |> maybe_limit(limit_options)
    |> order_by(^sort_options)
  end

  @doc utils: :query
  def maybe_where(query, options, valid_options) do
    Enum.reduce(valid_options, query, fn p, q ->
      if !is_nil(options[p]) and is_boolean(options[p]),
        do: where(q, [_s, e], field(e, ^p) == ^options[p]),
        else: q
    end)
  end

  @doc utils: :query
  def maybe_limit(query, nil), do: query
  @doc utils: :query
  def maybe_limit(query, limit), do: limit(query, ^limit)

  @doc utils: :query
  def create_with_entity(schema, attrs, entity_attrs) do
    {:ok, entity} = create_entity(entity_attrs)

    do_create_with_entity(schema, attrs, entity)
  end

  @doc utils: :query
  def create_with_entity(schema, %{"entity" => entity} = attrs) do
    {:ok, entity} = create_entity(entity)

    do_create_with_entity(schema, attrs, entity)
  end

  @doc utils: :query
  def create_with_entity(schema, attrs) do
    {:ok, entity} = create_entity()

    do_create_with_entity(schema, attrs, entity)
  end

  @doc utils: :query
  defp do_create_with_entity(schema, attrs, entity) do
    Repo.transaction(fn ->
      schema_attrs =
        attrs
        |> key_to_atom()
        |> Map.put(:entity_id, entity.id)

      changeset =
        schema
        |> Kernel.struct()
        |> schema.changeset(schema_attrs)

      case Repo.insert(changeset) do
        {:ok, item} ->
          item
          |> Repo.preload(@preloads)

        {:error, changeset} ->
          Repo.rollback(changeset)
      end
    end)
  end

  @doc utils: :query
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
