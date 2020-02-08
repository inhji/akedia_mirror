defmodule AkediaWeb.PostView do
  use AkediaWeb, :view

  def render("meta.index.html", assigns) do
    [title("Posts", assigns)]
  end

  def render("meta.show.html", assigns) do
    [title(assigns.post, assigns)]
  end
end
