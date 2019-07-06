defmodule AkediaWeb.FeedView do
  use AkediaWeb, :view

  def render("meta.show.html", assigns) do
    [title(assigns.feed.title, assigns)]
  end

  def render("meta.edit.html", assigns) do
    [title("Edit '#{assigns.feed.title}'", assigns)]
  end
end
