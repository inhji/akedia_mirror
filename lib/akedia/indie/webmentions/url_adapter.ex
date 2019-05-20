defmodule Akedia.Indie.Webmentions.URLAdapter do
  @behaviour IndieWeb.Webmention.URIAdapter

  def from_source_url(url) do
    Akedia.Indie.Micropub.Content.get_post_by_url(url)
  end

  def to_source_url(%Akedia.Content.Bookmark{} = bookmark), do: Akedia.url(bookmark)
  def to_source_url(%Akedia.Content.Post{} = post), do: Akedia.url(post)
end
