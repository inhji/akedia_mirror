defmodule AkediaWeb.PublicView do
  use AkediaWeb, :view
  import Scrivener.HTML
  alias AkediaWeb.{BookmarkView, PostView, LikeView}

  def render("meta.index.html", assigns) do
    [title(assigns)]
  end

  def render("meta.tagged.html", assigns) do
    [title("Tagged with '#{assigns.topic.text}'", assigns)]
  end

  def post_class(post) do
    IO.inspect(post)
  	if String.length(post.content_sanitized) > 200 do
  	  "width-2"
  	else
  	  ""
  	end
  end
end
