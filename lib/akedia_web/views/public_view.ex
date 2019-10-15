defmodule AkediaWeb.PublicView do
  use AkediaWeb, :view
  import Scrivener.HTML
  alias AkediaWeb.{BookmarkView, PostView, LikeView}

  @max_title_length 50
  @max_content_length 200

  def render("meta.index.html", assigns) do
    [title(assigns)]
  end

  def render("meta.tagged.html", assigns) do
    [title("Tagged with '#{assigns.topic.text}'", assigns)]
  end

  def post_class(post) do
    if String.length(post.content_sanitized) > @max_content_length do
      "width-2"
    else
      ""
    end
  end

  def like_class(like) do
    if String.length(like.title) > @max_title_length do
      "width-2"
    else
      ""
    end
  end

  def bookmark_class(bookmark) do
    cond do
      not is_nil(bookmark.title) and String.length(bookmark.title) > @max_title_length ->
        "width-2"

      not is_nil(bookmark.content) and String.length(bookmark.content) > @max_content_length ->
        "width-2"

      true ->
        ""
    end
  end
end
