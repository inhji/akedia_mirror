defmodule AkediaWeb.BookmarkView do
  use AkediaWeb, :view

  def render("meta.index.html", _assigns) do
    ~E{
      <title>Lesezeichen · Akedia</title>
    }
  end

  def render("meta.show.html", assigns) do
    ~E{
      <title><%= @bookmark.title %> · Akedia</title>
    }
  end

  def tld(url) do
    URI.parse(url).host
  end
end
