defmodule Akedia.Workers.Context do
  require Logger
  use Que.Worker
  alias Akedia.Content.Like

  def perform(%Like{url: url, entity: entity} = _like) do
    with author_map <- get_author(url),
         content_map <- get_content(url) do
      IO.inspect(author_map)
      IO.inspect(content_map)

      Logger.debug("Creating author..")

      {:ok, author} =
        author_map
        |> Map.drop([:photo])
        |> Akedia.Indie.maybe_create_author()

      Logger.debug("Saving author photo..")

      {:ok, author} = Akedia.Indie.update_author(author, %{photo: author_map[:photo]})

      Logger.debug("Creating context..")

      {:ok, context} =
        content_map
        |> Map.drop([:photo])
        |> Map.put_new(:author_id, author.id)
        |> Map.put_new(:entity_id, entity.id)
        |> Akedia.Indie.maybe_create_context()

      Logger.debug("Saving context photo..")

      {:ok, context} = Akedia.Indie.update_context(context, %{photo: content_map[:photo]})
    else
      {:error, error} ->
        Logger.warn("Context fetching failed: #{inspect(error)}")
    end
  end

  def get_content(url) do
    Enum.reduce_while(
      [
        &maybe_get_content_from_activitypub/1,
        &maybe_get_content_from_microformats/1
      ],
      nil,
      fn strategy, _ ->
        case strategy.(url) do
          {:error, _} -> {:cont, nil}
          {:ok, content} -> {:halt, content}
        end
      end
    )
  end

  def get_author(url) do
    Enum.reduce_while(
      [
        &maybe_get_author_from_activitypub/1,
        &maybe_get_author_from_microformats/1
      ],
      nil,
      fn strategy, _ ->
        case strategy.(url) do
          {:error, _} -> {:cont, nil}
          {:ok, author} -> {:halt, author}
        end
      end
    )
  end

  def maybe_get_content_from_microformats(url) do
    case Akedia.Indie.Microformats.fetch(url) do
      {:ok, %{items: [item]}} ->
        [content_map] = get_in(item, [:properties, :content])
        [published_at] = get_in(item, [:properties, :published])

        %{html: content_html, text: content} = content_map

        {:ok,
         %{
           content: content,
           content_html: content_html,
           published_at: Akedia.DateTime.to_datetime_utc(published_at),
           url: url
         }}

      _ ->
        {:error, :microformats_error}
    end
  end

  def maybe_get_content_from_activitypub(url) do
    case Akedia.ActivityPub.Discovery.fetch(url) do
      {:ok, object} ->
        photo =
          if !Enum.empty?(Map.get(object, "attachment")) do
            object
            |> Map.get("attachment")
            |> hd
            |> Map.get("url")
          else
            nil
          end

        {:ok,
         %{
           content: Map.get(object, "content"),
           content_html: Map.get(object, "content"),
           published_at: Akedia.DateTime.to_datetime_utc(Map.get(object, "published")),
           url: url,
           photo: photo
         }}

      _ ->
        {:error, :activitypub_error}
    end
  end

  def maybe_get_author_from_activitypub(url) do
    case Akedia.ActivityPub.Discovery.discover_actor(url) do
      {:ok, %{"icon" => icon, "name" => name, "url" => url, "preferredUsername" => username}} ->
        {:ok,
         %{
           name: name,
           url: url,
           username: username,
           photo: Map.get(icon, "url")
         }}

      {:error, error} ->
        {:error, error}
    end
  end

  def maybe_get_author_from_microformats(url) do
    case Akedia.Indie.Microformats.fetch(url) do
      {:ok, %{items: [item]}} ->
        [author] = get_in(item, [:properties, :author])
        [content_map] = get_in(item, [:properties, :content])
        [published_at] = get_in(item, [:properties, :published])
        [url] = get_in(item, [:properties, :url])

        %{
          name: [name],
          photo: [photo],
          url: [author_url]
        } = author.properties

        {:ok,
         %{
           name: name,
           photo: photo,
           url: author_url,
           username: nil
         }}

      {:error, error} ->
        Logger.warn(error)
        Logger.warn("Url #{url} does not contain microformats")

        {:error, :error}
    end
  end
end
