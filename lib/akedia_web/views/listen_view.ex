defmodule AkediaWeb.ListenView do
  use AkediaWeb, :view
  import Scrivener.HTML

  def render("meta.index.html", assigns) do
    [title("Listens", assigns)]
  end

  def render("meta.artists.html", assigns) do
    [title("Listens by Artist", assigns)]
  end
end
