defmodule Akedia.ContentTest do
  use Akedia.DataCase
  import Akedia.Factory

  alias Akedia.Content

  describe "stories" do
    alias Akedia.Content.Story

    @valid_attrs %{content: "some content", title: "some title"}
    @update_attrs %{
      content: "some updated content",
      title: "some updated title"
    }
    @invalid_attrs %{content: nil, slug: nil, title: nil}

    test "list_stories/0 returns all stories" do
      story = insert(:story)
      assert Content.list_stories() == [story]
    end

    test "get_story!/1 returns the story with given id" do
      story = insert(:story)
      assert Content.get_story!(story.slug) == story
    end

    test "create_story/1 with valid data creates a story" do
      assert {:ok, %Story{} = story} = Content.create_story(@valid_attrs)
      assert story.content == "some content"
      assert story.slug == "some-title"
      assert story.title == "some title"
    end

    test "create_story/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_story(@invalid_attrs)
    end

    test "update_story/2 with valid data updates the story" do
      story = insert(:story)
      assert {:ok, %Story{} = story} = Content.update_story(story, @update_attrs)
      assert story.content == "some updated content"
      assert story.title == "some updated title"
    end

    test "update_story2 with valid data leaves the slug intact" do
      story = insert(:story)
      assert {:ok, %Story{} = updated_story} = Content.update_story(story, @update_attrs)
      assert updated_story.slug == story.slug
    end

    test "update_story/2 with invalid data returns error changeset" do
      story = insert(:story)
      assert {:error, %Ecto.Changeset{}} = Content.update_story(story, @invalid_attrs)
      assert story == Content.get_story!(story.slug)
    end

    test "delete_story/1 deletes the story" do
      story = insert(:story)
      assert {:ok, %Story{}} = Content.delete_story(story)
      assert_raise Ecto.NoResultsError, fn -> Content.get_story!(story.slug) end
    end

    test "change_story/1 returns a story changeset" do
      story = insert(:story)
      assert %Ecto.Changeset{} = Content.change_story(story)
    end
  end
end
