defmodule Akedia.Context do
  @moduledoc """
  Fetches the context of a post from various sources
  """
  require Logger

  @doc """
  Fetches the post content
  """
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

  @doc """
  Fetches the post author
  """
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

  defp maybe_get_content_from_microformats(url) do
    case Akedia.Microformats2.parse(url) do
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

  defp maybe_get_content_from_activitypub(url) do
    case Akedia.ActivityPub.Discovery.fetch(url) do
      {:ok, object} ->
        photo =
          if Enum.empty?(Map.get(object, "attachment")) do
            nil
          else
            object
            |> Map.get("attachment")
            |> hd
            |> Map.get("url")
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

  defp maybe_get_author_from_activitypub(url) do
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

  defp maybe_get_author_from_microformats(url) do
    case Akedia.Microformats2.parse(url) do
      {:ok, %{items: [item]}} ->
        [author] = get_in(item, [:properties, :author])

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
