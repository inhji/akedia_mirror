defmodule AkediaWeb.LikeView do
  use AkediaWeb, :view

  def render("meta.index.html", assigns) do
    [title("Likes", assigns)]
  end

  def render("meta.show.html", assigns) do
    [title(assigns.like, assigns)]
  end
end
