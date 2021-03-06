defmodule AkediaWeb.PublicView do
  use AkediaWeb, :view
  import Scrivener.HTML
  alias AkediaWeb.{PostView, BookmarkView, LikeView}

  def render("meta.index.html", assigns) do
    [title(assigns)]
  end

  def render("meta.tagged.html", assigns) do
    [title("Tagged with '#{assigns.topic.text}'", assigns)]
  end
end
