defmodule Akedia.Webmentions.Worker do
  use Que.Worker
  require Logger
  alias Akedia.Content.{Post, Like, Bookmark}

  def perform(%Post{:reply_to => reply_url} = post) do
    Akedia.Webmentions.Bridgy.maybe_publish_to_github(post, reply_url)
    Akedia.Webmentions.send_webmentions(Akedia.entity_url(post), ".h-entry")

    :ok
  end

  def perform(%Like{:url => liked_url} = like) do
    Akedia.Webmentions.Bridgy.maybe_publish_to_github(like, liked_url)
    Akedia.Webmentions.send_webmentions(Akedia.entity_url(like), ".h-entry")

    :ok
  end

  def perform(%Bookmark{:url => bookmarked_url} = bookmark) do
    Akedia.Webmentions.Bridgy.maybe_publish_to_github(bookmark, bookmarked_url)
    Akedia.Webmentions.send_webmentions(Akedia.entity_url(bookmark), ".h-entry")

    :ok
  end
end
