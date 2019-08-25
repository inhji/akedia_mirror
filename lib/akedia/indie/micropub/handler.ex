defmodule Akedia.Indie.Micropub.Handler do
  @behaviour PlugMicropub.HandlerBehaviour
  require Logger

  alias Akedia.HTTP
  alias Akedia.Media
  alias Akedia.Indie.Micropub.{Properties, Content}
  alias Akedia.Indie.Auth.Token

  @impl true
  def handle_create(type, properties, access_token) do
    Logger.info("Micropub Handler engaged")
    Logger.info("Post type is #{inspect(type)}")
    Logger.info("Properies: #{inspect(properties)}")

    tags = Properties.get_tags(properties)
    title = Properties.get_title(properties)
    content = Properties.get_content(properties)
    is_published = Properties.is_published?(properties)
    photo = Properties.get_photo(properties)
    syndication_targets = Properties.get_syndication_targets(properties)

    case Token.verify_token(access_token, "create") do
      :ok ->
        case Properties.get_type_by_props(properties) do
          :bookmark ->
            Logger.info("Creating new bookmark..")
            url = Properties.get_bookmarked_url(properties)
            Content.create_bookmark(title, content, url, tags, is_published)

          :like ->
            Logger.info("Creating new like..")
            url = Properties.get_liked_url(properties)
            Content.create_like(url, is_published)

          :post ->
            Logger.info("Creating new post..")
            reply_to = Properties.get_reply_to(properties)

            Content.create_post(
              title,
              content,
              tags,
              reply_to,
              is_published,
              photo,
              syndication_targets
            )

          :unknown ->
            Logger.warn("Unknown or unsupported post type")
            Logger.info("Properties:", props: properties)
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
            url = HTTP.abs_url(Akedia.url(), image_url)

            {:ok, url}

          {:error, _reason} ->
            {:error, :insufficient_scope}
        end

      error ->
        error
    end
  end

  def handle_media(_, _), do: {:error, :insufficient_scope}

  @impl true
  def handle_update(_, _, _, _, _) do
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
  def handle_config_query(access_token) do
    case Token.verify_token(access_token, nil) do
      :ok ->
        media_url = HTTP.abs_url(Akedia.url(), "/indie/micropub/media")
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
        response = %{
          "syndicate-to": [
            %{
              "uid" => "https://fed.brid.gy",
              "name" => "Brid.gy Fed"
            }
          ]
        }

        {:ok, response}

      error ->
        error
    end
  end
end
