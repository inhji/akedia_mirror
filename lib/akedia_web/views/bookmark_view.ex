defmodule AkediaWeb.BookmarkView do
  use AkediaWeb, :view

  def render("meta.index.html", assigns) do
    [title("Bookmarks", assigns)]
  end

  def render("meta.show.html", assigns) do
    [title(assigns.bookmark.title, assigns)]
  end

  def tld(url) do
    URI.parse(url).host
  end
end
