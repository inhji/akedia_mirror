defmodule AkediaWeb.PostView do
  use AkediaWeb, :view

  def render("meta.index.html", assigns) do
    [title("Posts", assigns)]
  end
end
