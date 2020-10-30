defmodule Akedia.Webmentions.Worker do
  use Que.Worker
  require Logger
  alias Akedia.Content.{Post, Like, Bookmark}
  alias Akedia.Webmentions.Bridgy
  alias Akedia.Indie

  def perform(%Post{:reply_to => reply_url} = post) do
    Bridgy.maybe_publish_to_github(post, reply_url)
    Akedia.Webmentions.send_webmentions(Akedia.entity_url(post), ".h-entry")

    :ok
  end

  def perform(%Like{:url => liked_url} = like) do
    Bridgy.maybe_publish_to_github(like, liked_url)
    Akedia.Webmentions.send_webmentions(Akedia.entity_url(like), ".h-entry")

    :ok
  end

  def perform(%Bookmark{:url => bookmarked_url} = bookmark) do
    Bridgy.maybe_publish_to_github(bookmark, bookmarked_url)
    Akedia.Webmentions.send_webmentions(Akedia.entity_url(bookmark), ".h-entry")

    :ok
  end
end
