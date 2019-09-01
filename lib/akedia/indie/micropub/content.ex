defmodule Akedia.Indie.Micropub.Content do
  require Logger
  alias Akedia.Workers
  alias Akedia.Content

  def create_bookmark(title, content, url, tags, is_published) do
    content =
      if content == "." do
        content = nil
      end

    attrs = %{
      "title" => title,
      "content" => content,
      "url" => url
    }

    case Content.create_bookmark(attrs, %{is_published: is_published}) do
      {:ok, bookmark} ->
        Que.add(Workers.Favicon, bookmark)
        Akedia.Content.add_tags(bookmark, tags)
        Logger.info("Bookmark created!")
        {:ok, :created, Akedia.url(bookmark)}

      {:error, error} ->
        Logger.warn("Error while creating bookmark: #{inspect(error)}")
        {:error, :invalid_request}
    end
  end

  def create_like(url, is_published) do
    attrs = %{"url" => url}

    case Content.create_like(attrs, %{is_published: is_published}) do
      {:ok, like} ->
        Que.add(Workers.Webmention, like)
        Que.add(Workers.URLScraper, like)
        Logger.info("Like created!")
        {:ok, :created, Akedia.url(like)}

      {:error, error} ->
        Logger.warn("Error while creating like: #{inspect(error)}")
        {:error, :invalid_request}
    end
  end

  def create_post(title, content, tags, reply_to, is_published, photo, targets) do
    attrs = %{"content" => content, "title" => title, "reply_to" => reply_to}

    bridgy_fed =
      targets
      |> Enum.any?(fn t -> t == "https://fed.brid.gy/" end)

    case Content.create_post(attrs, %{is_published: is_published, bridgy_fed: bridgy_fed}) do
      {:ok, post} ->
        Que.add(Workers.Webmention, post)
        Logger.info("Post created!")
        Akedia.Media.maybe_create_image(photo, post.entity_id)
        Akedia.Content.add_tags(post, tags)
        {:ok, :created, Akedia.url(post)}

      {:error, error} ->
        Logger.warn("Error while creating post: #{inspect(error)}")
        {:error, :invalid_request}
    end
  end
end
