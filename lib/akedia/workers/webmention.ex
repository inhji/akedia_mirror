defmodule Akedia.Workers.Webmention do
  use Que.Worker
  require Logger
  alias Akedia.Content.{Post, Like, Bookmark}
  alias Akedia.Indie.Webmentions.Bridgy
  alias Akedia.Indie

  def perform(%Post{:reply_to => reply_url} = post) do
    Bridgy.maybe_publish_to_github(post, reply_url)
    Indie.Webmentions.do_send_webmentions(Akedia.url(post), ".h-entry")

    :ok
  end

  def perform(%Like{:url => liked_url} = like) do
    Bridgy.maybe_publish_to_github(like, liked_url)
    Indie.Webmentions.do_send_webmentions(Akedia.url(like), ".h-entry .title")

    :ok
  end

  def perform(%Bookmark{:url => bookmarked_url} = bookmark) do
    Bridgy.maybe_publish_to_github(bookmark, bookmarked_url)
    Indie.Webmentions.do_send_webmentions(Akedia.url(bookmark), ".h-entry .title")

    :ok
  end
end
