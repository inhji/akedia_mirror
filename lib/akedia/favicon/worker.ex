defmodule Akedia.Favicon.Worker do
  require Logger

  use Oban.Worker,
    queue: :default,
    max_attempts: 3

  alias Akedia.{Repo, Media}
  alias Akedia.Content.Bookmark
  alias Akedia.Microformats2.Hcard

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"entity_id" => entity_id}}) do
    entity = Akedia.Content.get_entity!(entity_id)
    bookmark = entity.bookmark

    case get_favicon(bookmark.url) do
      nil ->
        Logger.debug("No favicon found for #{bookmark.url}")

      favicon_url ->
        Logger.debug(favicon_url)

        favicon =
          bookmark.url
          |> Akedia.Helpers.hostname()
          |> maybe_create_favicon(favicon_url)

        bookmark
        |> Bookmark.changeset(%{favicon_id: favicon.id})
        |> Repo.update!()
    end

    :ok
  end

  def maybe_create_favicon(hostname, favicon_url) do
    case Media.get_favicon(hostname) do
      nil ->
        {:ok, favicon} = Media.create_favicon(%{hostname: hostname, name: favicon_url})
        favicon

      favicon ->
        favicon
    end
  end

  def maybe_get_favicon_from_hcard(url) do
    with {:ok, properties} <- Hcard.fetch_hcard(url),
         {:ok, %Hcard{photo: photo}} <- Hcard.parse(properties) do
      {:ok, photo}
    else
      {:error, _} -> {:error, :no_favicon_in_hcard}
    end
  end

  def maybe_get_favicon_from_head(url) do
    case Akedia.Favicon.fetch(url) do
      {:ok, favicon} ->
        {:ok, favicon}

      {:error, _error} ->
        {:error, :no_favicon_in_head}
    end
  end

  def get_favicon(url) do
    Enum.reduce_while(
      [
        &maybe_get_favicon_from_hcard/1,
        &maybe_get_favicon_from_head/1
      ],
      nil,
      fn strategy, acc ->
        case strategy.(url) do
          {:error, _} -> {:cont, acc}
          {:ok, favicon} -> {:halt, favicon}
        end
      end
    )
  end
end
