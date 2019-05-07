defmodule Akedia.ContentTest do
  use Akedia.DataCase
  import Akedia.Factory

  alias Akedia.Content

  describe "pages" do
    alias Akedia.Content.Page

    @valid_attrs %{
      content: "some content",
      title: "some title"
    }
    @update_attrs %{
      content: "some updated content",
      title: "some updated title"
    }
    @invalid_attrs %{content: nil, slug: nil, title: nil}

    test "list_pages/0 returns all pages" do
      page = insert(:page)
      assert Content.list_pages() == [page]
    end

    test "get_page!/1 returns the page with given slug" do
      page = insert(:page)
      assert Content.get_page!(page.slug) == page
    end

    test "create_page/1 with valid data creates a page" do
      assert {:ok, %Page{} = page} = Content.create_page(@valid_attrs)
      assert page.content == "some content"
      assert page.title == "some title"
    end

    test "create_page/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_page(@invalid_attrs)
    end

    test "update_page/2 with valid data updates the page" do
      page = insert(:page)
      assert {:ok, %Page{} = page} = Content.update_page(page, @update_attrs)
      assert page.content == "some updated content"
      assert page.title == "some updated title"
    end

    test "update_page/2 with valid data leaves the slug intact" do
      page = insert(:page)
      assert {:ok, %Page{} = updated_page} = Content.update_page(page, @update_attrs)
      assert updated_page.slug == page.slug
    end

    test "update_page/2 with invalid data returns error changeset" do
      page = insert(:page)
      assert {:error, %Ecto.Changeset{}} = Content.update_page(page, @invalid_attrs)
      assert page == Content.get_page!(page.slug)
    end

    test "delete_page/1 deletes the page" do
      page = insert(:page)
      assert {:ok, %Page{}} = Content.delete_page(page)
      assert_raise Ecto.NoResultsError, fn -> Content.get_page!(page.slug) end
    end

    test "change_page/1 returns a page changeset" do
      page = insert(:page)
      assert %Ecto.Changeset{} = Content.change_page(page)
    end
  end
end
