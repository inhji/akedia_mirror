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
  	if String.length(post.content_sanitized) > 200 do
  	  "width-2"
  	else
  	  ""
  	end
  end

  def bookmark_class(bookmark) do
    cond do
      not is_nil(bookmark.title) and String.length(bookmark.title) > 50 -> 
        "width-2"
      not is_nil(bookmark.content) and String.length(bookmark.content) > 200 -> 
        "width-2"
      true ->
        ""
    end
  end
end
