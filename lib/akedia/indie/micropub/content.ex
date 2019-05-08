defmodule Akedia.Indie.Micropub.Content do
  require Logger
  alias Akedia.Content
  alias Akedia.Workers.{FaviconScraper}
  alias AkediaWeb.Endpoint
  alias AkediaWeb.Router.Helpers, as: Routes

  @url_types_regex ~r/\/(?<type>bookmarks|stories|posts)\/(?<slug>[\w\d-]*)\/?$/

  def create_bookmark(title, content, url, tags, is_published) do
    attrs = %{
      "title" => title,
      "content" => content,
      "url" => url
    }

    case Content.create_bookmark(attrs, is_published) do
      {:ok, bookmark} ->
        Que.add(FaviconScraper, bookmark)
        Akedia.Content.add_tags(bookmark, tags)
        Logger.info("Bookmark created!")
        {:ok, :created, Routes.bookmark_url(Endpoint, :show, bookmark)}

      {:error, error} ->
        Logger.warn("Error while creating bookmark: #{inspect(error)}")
        {:error, :invalid_request}
    end
  end

  def create_like(url, is_published) do
    attrs = %{"url" => url}

    case Content.create_like(attrs, is_published) do
      {:ok, like} ->
        Logger.info("Like created!")
        {:ok, :created, Routes.like_url(Endpoint, :show, like)}

      {:error, error} ->
        Logger.warn("Error while creating like: #{inspect(error)}")
        {:error, :invalid_request}
    end
  end

  def create_post(title, content, tags, reply_to, is_published) do
    attrs = %{"content" => content, "title" => title, "reply_to" => reply_to}

    case Content.create_post(attrs, is_published) do
      {:ok, post} ->
        Logger.info("Post created!")
        Akedia.Content.add_tags(post, tags)
        {:ok, :created, Routes.post_url(Endpoint, :show, post)}

      {:error, error} ->
        Logger.warn("Error while creating post: #{inspect(error)}")
        {:error, :invalid_request}
    end
  end

  def get_post_by_url(url) do
    case Regex.named_captures(@url_types_regex, url) do
      %{"type" => "bookmarks", "slug" => slug} ->
        Akedia.Content.get_bookmark!(slug)

      %{"type" => "posts", "slug" => slug} ->
        Akedia.Content.get_post!(slug)

      %{"type" => "stories", "slug" => slug} ->
        Akedia.Content.get_story!(slug)

      nil ->
        nil
    end
  end
end
