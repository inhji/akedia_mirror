defmodule AkediaWeb.PublicView do
  use AkediaWeb, :view
  import Scrivener.HTML

  def render("meta.index.html", assigns) do
    [title("Home", assigns)]
  end
end
