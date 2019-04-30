defmodule Akedia.Indie.Micropub.Handler do
  @behaviour PlugMicropub.HandlerBehaviour
  require Logger

  alias Akedia.{Content, Media}
  alias Akedia.Content.Bookmark
  alias Akedia.Indie.Micropub.{Token, Properties}
  alias AkediaWeb.Router.Helpers, as: Routes
  alias AkediaWeb.Endpoint
  alias Akedia.Workers.URLScraper

  @url_types_regex ~r/\/(?<type>bookmarks|stories)\/(?<slug>[\w\d-]*)\/?$/

  @impl true
  def handle_create(type, properties, access_token) do
    Logger.info("Micropub Handler engaged")
    Logger.info("Post type is #{inspect(type)}")
    Logger.info("Properies: #{inspect(properties)}")

    tags = get_tags(properties)
    title = get_title(properties)
    content = get_content(properties)
    is_published = is_published?(properties)

    case Token.verify_token(access_token, "create") do
      :ok ->
        case get_type_by_props(properties) do
          :bookmark ->
            Logger.info("Creating new bookmark..")
            url = get_bookmarked_url(properties)
            create_bookmark(title, content, url, tags, is_published)

          :like ->
            Logger.info("Creating new like..")
            url = get_liked_url(properties)
            create_like(url, is_published)

          :unknown ->
            Logger.warn("Unknown or unsupported post type")
            Logger.info("Properties:", [props: properties])
            {:error, :insufficient_scope}
        end

      error ->
        error
    end
  end

  @impl true
  def handle_media([file], access_token) do
    Logger.info("Micropub Media Handler engaged")
    Logger.info("Uploaded file is #{inspect(file)}")

    attrs = %{"name" => file, "text" => file.filename}

    case Token.verify_token(access_token, "media") do
      :ok ->
        case Media.create_image(attrs) do
          {:ok, image} ->
            image_url = Media.ImageUploader.url({image.name, image}, :original)
            url = abs_url(Akedia.url(), image_url)

            {:ok, url}

          {:error, _reason} ->
            {:error, :insufficient_scope}
        end

      error ->
        error
    end
  end

  def handle_media(_, _), do: {:error, :insufficient_scope}

  # TODO: This is untested!
  @impl true
  def handle_update(url, replace, add, delete, access_token) do
    case Token.verify_token(access_token, "update") do
      :ok ->
        attrs = Properties.parse(replace, add, delete)

        case get_post_by_url(url) do
          %Bookmark{} = bookmark ->
            Content.update_bookmark(bookmark, attrs)

          nil ->
            {:error, :invalid_request, "The post with the requested URL was not found"}
        end

      error ->
        error
    end
  end

  @impl true
  def handle_delete(_url, _access_token) do
    {:error, :insufficient_scope}
  end

  @impl true
  def handle_undelete(_url, _access_token) do
    {:error, :insufficient_scope}
  end

  @impl true
  def handle_config_query(access_token) do
    case Token.verify_token(access_token, nil) do
      :ok ->
        media_url = abs_url(Akedia.url(), "/indie/micropub/media")
        response = %{"media-endpoint": media_url, "syndicate-to": []}
        {:ok, response}

      error ->
        error
    end
  end

  @impl true
  def handle_source_query(_url, _filter_properties, _access_token) do
    {:error, :insufficient_scope}
  end

  @impl true
  def handle_syndicate_to_query(access_token) do
    case Token.verify_token(access_token, nil) do
      :ok ->
        response = %{"syndicate-to": []}
        {:ok, response}

      error ->
        error
    end
  end

  def get_post_by_url(url) do
    case Regex.named_captures(@url_types_regex, url) do
      %{"type" => "bookmarks", "slug" => slug} ->
        Content.get_bookmark!(slug)

      nil ->
        nil
    end
  end

  @spec abs_url(binary(), binary()) :: binary()
  def abs_url(base, relative_path) do
    base
    |> URI.parse()
    |> URI.merge(relative_path)
    |> to_string()
  end

  def create_bookmark(title, content, url, tags, is_published) do
    attrs = %{
      "title" => title || Slugger.slugify(url),
      "content" => content,
      "url" => url
    }

    case Content.create_bookmark(attrs, is_published) do
      {:ok, bookmark} ->
        Que.add(URLScraper, bookmark)
        Content.add_tags(bookmark, tags)
        Logger.info("Bookmark created!")
        {:ok, :created, Routes.bookmark_url(Endpoint, :show, bookmark)}

      {:error, error} ->
        Logger.warn("Error while creating bookmark", [error: error])
        {:error, :invalid_request}
    end
  end

  def create_like(url, is_published) do
    attrs = %{ "url" => url }

    case Content.create_like(attrs, is_published) do
     {:ok, like} ->
        Logger.info("Bookmark created!")
        {:ok, :created, Routes.like_url(Endpoint, :show, like)}
      {:error, error} ->
        Logger.warn("Error while creating like", [error: error])
        {:error, :invalid_request}
    end
  end

  def get_type_by_props(%{"bookmark-of" => _}), do: :bookmark
  def get_type_by_props(%{"like-of" => _}), do: :like
  def get_type_by_props(_), do: :unknown

  def get_tags(%{"category" => tags}), do: tags
  def get_tags(_), do: []

  def get_title(%{"name" => [title]}), do: title
  def get_title(_), do: nil

  def get_content(%{"content" => [content]}), do: content
  def get_content(%{"content" => [%{"html" => [content_html]}]}), do: content_html
  def get_content(_), do: nil

  def get_bookmarked_url(%{"bookmark-of" => [url]}), do: url
  def get_bookmarked_url(_), do: nil

  def get_liked_url(%{"like-of" => [url]}), do: url
  def get_liked_url(_), do: nil

  def is_published?(%{"post-status" => ["draft"]}), do: false
  def is_published?(_), do: true
end
