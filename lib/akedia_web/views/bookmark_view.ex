defmodule AkediaWeb.BookmarkView do
  use AkediaWeb, :view

  def render("meta.index.html", _assigns) do
    ~E{
      <title>Bookmarks</title>
    }
  end

  def render("meta.show.html", assigns) do
    ~E{
      <title>Bookmark: <%= @bookmark.title %></title>
    }
  end

  def tld(url) when is_binary(url) do
    URI.parse(url).host || url
  end
end
