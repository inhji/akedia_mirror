defmodule Akedia.Indie.Micropub.Handler do
  @behaviour PlugMicropub.HandlerBehaviour
  require Logger

  alias Akedia.{Content, Media}
  alias AkediaWeb.Router.Helpers, as: Routes
  alias AkediaWeb.Endpoint

  @impl true
  def handle_create(type, properties, access_token) do
    Logger.info("Micropub Handler engaged")
    Logger.debug("Post type is #{inspect(type)}")
    Logger.debug("Access token is #{inspect(access_token)}")

    tags = get_tags(properties)
    title = get_title(properties)
    content = get_content(properties)
    url = get_url(properties)
    is_published = is_published?(properties)

    case get_type(properties) do
      "bookmark" ->
        Logger.info("Creating new bookmark..")
        create_bookmark(title, content, url, tags, is_published)

      "unknown" ->
        Logger.warn("Unknown or unsupported post type")
        Logger.debug("Properties: #{inspect(properties, pretty: true)}")
        {:error, :insufficient_scope}
    end
  end

  @impl true
  def handle_media([file], _access_token) do
    Logger.info("Micropub Media Handler engaged")
    Logger.info("Uploaded file is #{inspect(file)}")

    attrs = %{"name" => file, "text" => file.filename}

    case Media.create_image(attrs) do
      {:ok, image} ->
        image_url = Media.ImageUploader.url({image.name, image}, :original)
        url = abs_url(Routes.url(Endpoint), image_url)

        {:ok, url}

      {:error, _reason} ->
        {:error, :insufficient_scope}
    end
  end
  def handle_media(_, _), do: {:error, :insufficient_scope}

  @impl true
  def handle_update(_url, _replace, _add, _delete, _access_token) do
    {:error, :insufficient_scope}
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
  @spec handle_config_query(any()) :: {:ok, %{"media-endpoint": any(), "syndicate-to": []}}
  def handle_config_query(_access_token) do
    media_url = abs_url(Routes.url(Endpoint), "/indie/micropub/media")
    # media_url = abs_url("https://c31bb8f4.ngrok.io", "/indie/micropub/media")
    response = %{"media-endpoint": media_url, "syndicate-to": []}

    {:ok, response}
  end

  @impl true
  def handle_source_query(_url, _filter_properties, _access_token) do
    {:error, :insufficient_scope}
  end

  def abs_url(base, relative_path) do
    base
    |> URI.parse()
    |> URI.merge(relative_path)
    |> to_string()
  end

  def create_bookmark(title, content, url, tags, is_published) do
    attrs = %{
      "title" => title,
      "content" => content,
      "url" => url
    }

    case Content.create_bookmark(attrs, is_published) do
      {:ok, bookmark} ->
        Content.add_tags(bookmark, tags)
        Logger.info("Bookmark created!")
        {:ok, :created, Routes.bookmark_url(Endpoint, :show, bookmark)}

      {:error, _error} ->
        {:error, :insufficient_scope}
    end
  end

  def get_type(%{"bookmark-of" => _bookmark_of}), do: "bookmark"
  def get_type(_), do: "unknown"

  def get_tags(%{"category" => tags}), do: tags
  def get_tags(_), do: []

  def get_title(%{"name" => [title]}), do: title
  def get_title(_), do: nil

  def get_content(%{"content" => [content]}), do: content
  def get_content(%{"content" => [%{"html" => [content_html]}]}), do: content_html
  def get_content(_), do: nil

  def get_url(%{"bookmark-of" => [url]}), do: url
  def get_url(_), do: nil

  def is_published?(%{"post-status" => ["draft"]}), do: false
  def is_published?(_), do: true
end
