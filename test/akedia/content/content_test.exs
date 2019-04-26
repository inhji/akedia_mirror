defmodule Akedia.ContentTest do
  use Akedia.DataCase

  alias Akedia.Content

  describe "entities" do
    alias Akedia.Content.Entity

    @valid_attrs %{is_pinned: true, is_published: true}
    @update_attrs %{is_pinned: false, is_published: false}
    @invalid_attrs %{is_pinned: nil, is_published: nil}

    def entity_fixture(attrs \\ %{}) do
      {:ok, entity} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_entity()

      entity
    end

    test "list_entities/0 returns all entities" do
      entity = entity_fixture()
      assert Content.list_entities() == [entity]
    end

    test "get_entity!/1 returns the entity with given id" do
      entity = entity_fixture()
      assert Content.get_entity!(entity.id) == entity
    end

    test "create_entity/1 with valid data creates a entity" do
      assert {:ok, %Entity{} = entity} = Content.create_entity(@valid_attrs)
      assert entity.is_pinned == true
      assert entity.is_published == true
    end

    test "create_entity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_entity(@invalid_attrs)
    end

    test "update_entity/2 with valid data updates the entity" do
      entity = entity_fixture()
      assert {:ok, %Entity{} = entity} = Content.update_entity(entity, @update_attrs)
      assert entity.is_pinned == false
      assert entity.is_published == false
    end

    test "update_entity/2 with invalid data returns error changeset" do
      entity = entity_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_entity(entity, @invalid_attrs)
      assert entity == Content.get_entity!(entity.id)
    end

    test "delete_entity/1 deletes the entity" do
      entity = entity_fixture()
      assert {:ok, %Entity{}} = Content.delete_entity(entity)
      assert_raise Ecto.NoResultsError, fn -> Content.get_entity!(entity.id) end
    end

    test "change_entity/1 returns a entity changeset" do
      entity = entity_fixture()
      assert %Ecto.Changeset{} = Content.change_entity(entity)
    end
  end

  describe "stories" do
    alias Akedia.Content.Story

    @valid_attrs %{content: "some content", slug: "some slug", title: "some title"}
    @update_attrs %{content: "some updated content", slug: "some updated slug", title: "some updated title"}
    @invalid_attrs %{content: nil, slug: nil, title: nil}

    def story_fixture(attrs \\ %{}) do
      {:ok, story} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_story()

      story
    end

    test "list_stories/0 returns all stories" do
      story = story_fixture()
      assert Content.list_stories() == [story]
    end

    test "get_story!/1 returns the story with given id" do
      story = story_fixture()
      assert Content.get_story!(story.id) == story
    end

    test "create_story/1 with valid data creates a story" do
      assert {:ok, %Story{} = story} = Content.create_story(@valid_attrs)
      assert story.content == "some content"
      assert story.slug == "some slug"
      assert story.title == "some title"
    end

    test "create_story/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_story(@invalid_attrs)
    end

    test "update_story/2 with valid data updates the story" do
      story = story_fixture()
      assert {:ok, %Story{} = story} = Content.update_story(story, @update_attrs)
      assert story.content == "some updated content"
      assert story.slug == "some updated slug"
      assert story.title == "some updated title"
    end

    test "update_story/2 with invalid data returns error changeset" do
      story = story_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_story(story, @invalid_attrs)
      assert story == Content.get_story!(story.id)
    end

    test "delete_story/1 deletes the story" do
      story = story_fixture()
      assert {:ok, %Story{}} = Content.delete_story(story)
      assert_raise Ecto.NoResultsError, fn -> Content.get_story!(story.id) end
    end

    test "change_story/1 returns a story changeset" do
      story = story_fixture()
      assert %Ecto.Changeset{} = Content.change_story(story)
    end
  end

  describe "pages" do
    alias Akedia.Content.Page

    @valid_attrs %{content: "some content", slug: "some slug", title: "some title"}
    @update_attrs %{content: "some updated content", slug: "some updated slug", title: "some updated title"}
    @invalid_attrs %{content: nil, slug: nil, title: nil}

    def page_fixture(attrs \\ %{}) do
      {:ok, page} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_page()

      page
    end

    test "list_pages/0 returns all pages" do
      page = page_fixture()
      assert Content.list_pages() == [page]
    end

    test "get_page!/1 returns the page with given id" do
      page = page_fixture()
      assert Content.get_page!(page.id) == page
    end

    test "create_page/1 with valid data creates a page" do
      assert {:ok, %Page{} = page} = Content.create_page(@valid_attrs)
      assert page.content == "some content"
      assert page.slug == "some slug"
      assert page.title == "some title"
    end

    test "create_page/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_page(@invalid_attrs)
    end

    test "update_page/2 with valid data updates the page" do
      page = page_fixture()
      assert {:ok, %Page{} = page} = Content.update_page(page, @update_attrs)
      assert page.content == "some updated content"
      assert page.slug == "some updated slug"
      assert page.title == "some updated title"
    end

    test "update_page/2 with invalid data returns error changeset" do
      page = page_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_page(page, @invalid_attrs)
      assert page == Content.get_page!(page.id)
    end

    test "delete_page/1 deletes the page" do
      page = page_fixture()
      assert {:ok, %Page{}} = Content.delete_page(page)
      assert_raise Ecto.NoResultsError, fn -> Content.get_page!(page.id) end
    end

    test "change_page/1 returns a page changeset" do
      page = page_fixture()
      assert %Ecto.Changeset{} = Content.change_page(page)
    end
  end

  describe "bookmarks" do
    alias Akedia.Content.Bookmark

    @valid_attrs %{content: "some content", title: "some title", url: "some url"}
    @update_attrs %{content: "some updated content", title: "some updated title", url: "some updated url"}
    @invalid_attrs %{content: nil, title: nil, url: nil}

    def bookmark_fixture(attrs \\ %{}) do
      {:ok, bookmark} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_bookmark()

      bookmark
    end

    test "list_bookmarks/0 returns all bookmarks" do
      bookmark = bookmark_fixture()
      assert Content.list_bookmarks() == [bookmark]
    end

    test "get_bookmark!/1 returns the bookmark with given id" do
      bookmark = bookmark_fixture()
      assert Content.get_bookmark!(bookmark.id) == bookmark
    end

    test "create_bookmark/1 with valid data creates a bookmark" do
      assert {:ok, %Bookmark{} = bookmark} = Content.create_bookmark(@valid_attrs)
      assert bookmark.content == "some content"
      assert bookmark.title == "some title"
      assert bookmark.url == "some url"
    end

    test "create_bookmark/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_bookmark(@invalid_attrs)
    end

    test "update_bookmark/2 with valid data updates the bookmark" do
      bookmark = bookmark_fixture()
      assert {:ok, %Bookmark{} = bookmark} = Content.update_bookmark(bookmark, @update_attrs)
      assert bookmark.content == "some updated content"
      assert bookmark.title == "some updated title"
      assert bookmark.url == "some updated url"
    end

    test "update_bookmark/2 with invalid data returns error changeset" do
      bookmark = bookmark_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_bookmark(bookmark, @invalid_attrs)
      assert bookmark == Content.get_bookmark!(bookmark.id)
    end

    test "delete_bookmark/1 deletes the bookmark" do
      bookmark = bookmark_fixture()
      assert {:ok, %Bookmark{}} = Content.delete_bookmark(bookmark)
      assert_raise Ecto.NoResultsError, fn -> Content.get_bookmark!(bookmark.id) end
    end

    test "change_bookmark/1 returns a bookmark changeset" do
      bookmark = bookmark_fixture()
      assert %Ecto.Changeset{} = Content.change_bookmark(bookmark)
    end
  end

  describe "topics" do
    alias Akedia.Content.Topic

    @valid_attrs %{text: "some text"}
    @update_attrs %{text: "some updated text"}
    @invalid_attrs %{text: nil}

    def topic_fixture(attrs \\ %{}) do
      {:ok, topic} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_topic()

      topic
    end

    test "list_topics/0 returns all topics" do
      topic = topic_fixture()
      assert Content.list_topics() == [topic]
    end

    test "get_topic!/1 returns the topic with given id" do
      topic = topic_fixture()
      assert Content.get_topic!(topic.id) == topic
    end

    test "create_topic/1 with valid data creates a topic" do
      assert {:ok, %Topic{} = topic} = Content.create_topic(@valid_attrs)
      assert topic.text == "some text"
    end

    test "create_topic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_topic(@invalid_attrs)
    end

    test "update_topic/2 with valid data updates the topic" do
      topic = topic_fixture()
      assert {:ok, %Topic{} = topic} = Content.update_topic(topic, @update_attrs)
      assert topic.text == "some updated text"
    end

    test "update_topic/2 with invalid data returns error changeset" do
      topic = topic_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_topic(topic, @invalid_attrs)
      assert topic == Content.get_topic!(topic.id)
    end

    test "delete_topic/1 deletes the topic" do
      topic = topic_fixture()
      assert {:ok, %Topic{}} = Content.delete_topic(topic)
      assert_raise Ecto.NoResultsError, fn -> Content.get_topic!(topic.id) end
    end

    test "change_topic/1 returns a topic changeset" do
      topic = topic_fixture()
      assert %Ecto.Changeset{} = Content.change_topic(topic)
    end
  end

  describe "likes" do
    alias Akedia.Content.Like

    @valid_attrs %{url: "some url"}
    @update_attrs %{url: "some updated url"}
    @invalid_attrs %{url: nil}

    def like_fixture(attrs \\ %{}) do
      {:ok, like} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Content.create_like()

      like
    end

    test "list_likes/0 returns all likes" do
      like = like_fixture()
      assert Content.list_likes() == [like]
    end

    test "get_like!/1 returns the like with given id" do
      like = like_fixture()
      assert Content.get_like!(like.id) == like
    end

    test "create_like/1 with valid data creates a like" do
      assert {:ok, %Like{} = like} = Content.create_like(@valid_attrs)
      assert like.url == "some url"
    end

    test "create_like/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_like(@invalid_attrs)
    end

    test "update_like/2 with valid data updates the like" do
      like = like_fixture()
      assert {:ok, %Like{} = like} = Content.update_like(like, @update_attrs)
      assert like.url == "some updated url"
    end

    test "update_like/2 with invalid data returns error changeset" do
      like = like_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_like(like, @invalid_attrs)
      assert like == Content.get_like!(like.id)
    end

    test "delete_like/1 deletes the like" do
      like = like_fixture()
      assert {:ok, %Like{}} = Content.delete_like(like)
      assert_raise Ecto.NoResultsError, fn -> Content.get_like!(like.id) end
    end

    test "change_like/1 returns a like changeset" do
      like = like_fixture()
      assert %Ecto.Changeset{} = Content.change_like(like)
    end
  end
end
