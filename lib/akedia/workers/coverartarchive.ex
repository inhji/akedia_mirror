defmodule Akedia.Workers.Coverartarchive do
  use Que.Worker
  require Logger
  alias HTTPoison.Response
  alias Akedia.Listens.{Listen, Artist, Album}
  alias Akedia.Repo

  def perform(_) do
    albums = Akedia.Listens.list_albums_with_mbid_but_no_cover()
    Enum.each(albums, &update_cover/1)
  end

  def update_cover(%{mbid: mbid, name: name, artist: artist} = album) do
    case fetch_coverart(mbid) do
      {:ok, url} ->
        Akedia.Listens.update_album(album, %{cover: url})

      _ ->
        Logger.warn("No album art found for #{name} by #{artist.name} (#{mbid})")
    end
  end

  def fetch_coverart(mbid) do
    url = "https://coverartarchive.org/release/#{mbid}/front"

    case HTTPoison.get!(url) do
      %Response{status_code: 307} ->
        {:ok, url}

      %Response{status_code: 404, body: body} ->
        {:error, body}

      error ->
        {:error, error}
    end
  end
end
