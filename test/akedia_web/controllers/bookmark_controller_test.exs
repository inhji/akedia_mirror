defmodule AkediaWeb.BookmarkControllerTest do
  use AkediaWeb.ConnCase

  alias Akedia.Content

  @create_attrs %{content: "some content", title: "some title", url: "some url"}
  @update_attrs %{content: "some updated content", title: "some updated title", url: "some updated url"}
  @invalid_attrs %{content: nil, title: nil, url: nil}

  def fixture(:bookmark) do
    {:ok, bookmark} = Content.create_bookmark(@create_attrs)
    bookmark
  end

  describe "index" do
    test "lists all bookmarks", %{conn: conn} do
      conn = get(conn, Routes.bookmark_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Bookmarks"
    end
  end

  describe "new bookmark" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.bookmark_path(conn, :new))
      assert html_response(conn, 200) =~ "New Bookmark"
    end
  end

  describe "create bookmark" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.bookmark_path(conn, :create), bookmark: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.bookmark_path(conn, :show, id)

      conn = get(conn, Routes.bookmark_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Bookmark"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.bookmark_path(conn, :create), bookmark: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Bookmark"
    end
  end

  describe "edit bookmark" do
    setup [:create_bookmark]

    test "renders form for editing chosen bookmark", %{conn: conn, bookmark: bookmark} do
      conn = get(conn, Routes.bookmark_path(conn, :edit, bookmark))
      assert html_response(conn, 200) =~ "Edit Bookmark"
    end
  end

  describe "update bookmark" do
    setup [:create_bookmark]

    test "redirects when data is valid", %{conn: conn, bookmark: bookmark} do
      conn = put(conn, Routes.bookmark_path(conn, :update, bookmark), bookmark: @update_attrs)
      assert redirected_to(conn) == Routes.bookmark_path(conn, :show, bookmark)

      conn = get(conn, Routes.bookmark_path(conn, :show, bookmark))
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn, bookmark: bookmark} do
      conn = put(conn, Routes.bookmark_path(conn, :update, bookmark), bookmark: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Bookmark"
    end
  end

  describe "delete bookmark" do
    setup [:create_bookmark]

    test "deletes chosen bookmark", %{conn: conn, bookmark: bookmark} do
      conn = delete(conn, Routes.bookmark_path(conn, :delete, bookmark))
      assert redirected_to(conn) == Routes.bookmark_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.bookmark_path(conn, :show, bookmark))
      end
    end
  end

  defp create_bookmark(_) do
    bookmark = fixture(:bookmark)
    {:ok, bookmark: bookmark}
  end
end
