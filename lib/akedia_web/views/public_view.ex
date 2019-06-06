defmodule AkediaWeb.PublicView do
  use AkediaWeb, :view

  def render("meta.index.html", assigns) do
    [title("Home", assigns)]
  end
end
