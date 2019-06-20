defmodule AkediaWeb.PublicView do
  use AkediaWeb, :view
  import Scrivener.HTML
  alias AkediaWeb.{BookmarkView, PostView, LikeView}

  def render("meta.index.html", assigns) do
    [title("Home", assigns)]
  end
end
