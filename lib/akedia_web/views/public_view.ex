defmodule AkediaWeb.PublicView do
  use AkediaWeb, :view
  alias AkediaWeb.{BookmarkView, PostView, LikeView}

  def render("meta.index.html", assigns) do
    [title("Home", assigns)]
  end
end
