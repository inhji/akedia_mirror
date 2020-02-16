defmodule Akedia.Indie.Micropub.Content do
  require Logger
  alias Akedia.Content

  def enable_bridgy_fed?(targets) do
    Enum.any?(targets, fn t -> t == "https://fed.brid.gy/" end)
  end

  def create_bookmark(title, content, url, tags, is_published, targets) do
    content =
      if content == "." do
        nil
      else
        content
      end

    attrs = %{
      "title" => title,
      "content" => content,
      "url" => url
    }

    bridgy_fed = enable_bridgy_fed?(targets)

    Logger.info("Creating bookmark: #{inspect(attrs)}")

    case Content.create_bookmark(attrs, %{is_published: is_published, bridgy_fed: bridgy_fed}) do
      {:ok, bookmark} ->
        Que.add(Akedia.Favicon.Worker, bookmark)
        Akedia.Content.add_tags(bookmark, tags)
        Logger.info("Bookmark created: #{inspect(bookmark)}")
        {:ok, :created, Akedia.entity_url(bookmark)}

      {:error, error} ->
        Logger.warn("Error while creating bookmark: #{inspect(error)}")
        {:error, :invalid_request}
    end
  end

  def create_like(url, is_published, targets) do
    attrs = %{"url" => url}
    bridgy_fed = enable_bridgy_fed?(targets)

    Logger.info("Creating like: #{inspect(attrs)}")

    case Content.create_like(attrs, %{is_published: is_published, bridgy_fed: bridgy_fed}) do
      {:ok, like} ->
        Que.add(Workers.Webmention, like)
        Que.add(Workers.Context, like)
        Logger.info("Like created!")
        {:ok, :created, Akedia.entity_url(like)}

      {:error, error} ->
        Logger.warn("Error while creating like: #{inspect(error)}")
        {:error, :invalid_request}
    end
  end

  def create_post(title, content, tags, reply_to, is_published, photo, targets) do
    attrs = %{"content" => content, "title" => title, "reply_to" => reply_to}
    bridgy_fed = enable_bridgy_fed?(targets)

    case Content.create_post(attrs, %{is_published: is_published, bridgy_fed: bridgy_fed}) do
      {:ok, post} ->
        Que.add(Workers.Webmention, post)
        Logger.info("Post created!")
        Akedia.Media.maybe_create_image(photo, post.entity_id)
        Akedia.Content.add_tags(post, tags)
        {:ok, :created, Akedia.entity_url(post)}

      {:error, error} ->
        Logger.warn("Error while creating post: #{inspect(error)}")
        {:error, :invalid_request}
    end
  end
end
