defmodule AkediaWeb.SearchView do
  use AkediaWeb, :view
  alias AkediaWeb.{BookmarkView, PostView, LikeView}

  def render("meta.search.html", assigns) do
    [title("Search", assigns)]
  end

end
