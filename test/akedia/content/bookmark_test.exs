defmodule Akedia.ContentTest do
  use Akedia.DataCase
  import Akedia.Factory

  alias Akedia.Content

  describe "bookmarks" do
    alias Akedia.Content.Bookmark

    @valid_attrs %{content: "some content", title: "some title", url: "some url"}
    @update_attrs %{
      content: "some updated content",
      title: "some updated title",
      url: "some updated url"
    }
    @invalid_attrs %{content: nil, title: nil, url: nil}

    test "list_bookmarks/0 returns all bookmarks" do
      bookmark = insert(:bookmark)
      assert Content.list_bookmarks() == [bookmark]
    end

    test "get_bookmark!/1 returns the bookmark with given slug" do
      bookmark = insert(:bookmark)
      assert Content.get_bookmark!(bookmark.slug) == bookmark
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
      bookmark = insert(:bookmark)
      assert {:ok, %Bookmark{} = bookmark} = Content.update_bookmark(bookmark, @update_attrs)
      assert bookmark.content == "some updated content"
      assert bookmark.title == "some updated title"
      assert bookmark.url == "some updated url"
    end

    test "update_bookmark/2 with invalid data returns error changeset" do
      bookmark = insert(:bookmark)
      assert {:error, %Ecto.Changeset{}} = Content.update_bookmark(bookmark, @invalid_attrs)
      assert bookmark == Content.get_bookmark!(bookmark.slug)
    end

    test "delete_bookmark/1 deletes the bookmark" do
      bookmark = insert(:bookmark)
      assert {:ok, %Bookmark{}} = Content.delete_bookmark(bookmark)
      assert_raise Ecto.NoResultsError, fn -> Content.get_bookmark!(bookmark.slug) end
    end

    test "change_bookmark/1 returns a bookmark changeset" do
      bookmark = insert(:bookmark)
      assert %Ecto.Changeset{} = Content.change_bookmark(bookmark)
    end
  end
end
