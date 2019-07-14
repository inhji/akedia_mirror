defmodule Akedia.Listens do
  import Ecto.Query, warn: false
  alias Akedia.Repo
  alias Akedia.Listens.{Listen, Artist, Album}

  def listens_paginated(params) do
    Listen
    |> order_by(desc: :listened_at)
    |> preload([:artist, :album])
    |> Repo.paginate(params)
  end

  def listens(limit \\ 10) do
    Listen
    |> order_by(desc: :listened_at)
    |> limit(^limit)
    |> preload([:artist, :album])
    |> Repo.one!()
  end

  def get_oldest_listen() do
    Listen
    |> order_by(desc: :listened_at)
    |> limit(1)
    |> Repo.one!()
  end

  def group_by_artist(time_diff \\ nil) do
    group_by_artist_query(time_diff)
    |> Repo.all()
  end

  def group_by_artist_query(time_diff \\ nil) do
    Listen
    |> join(:left, [l], a in Artist, on: l.artist_id == a.id)
    |> group_by([l, a], a.name)
    |> maybe_limit_by_time_diff(time_diff)
    |> select([listen, artist], %{
      listens: fragment("count (?) as listens", listen.id),
      artist: artist.name
    })
    |> limit(100)
    |> order_by(desc: fragment("listens"))
  end

  def group_by_album_query() do
    Listen
    |> join(:left, [l], a in Album, on: l.album_id == a.id)
    |> group_by([l, a], a.id)
    |> select([l, a], %{
      listens: fragment("count (?) as listens", l.id),
      id: a.id
    })
    |> order_by(desc: fragment("listens"))
  end

  def group_by_album(limit \\ 9, time_diff \\ nil) do
    group_by_album_query()
    |> maybe_limit_by_time_diff(time_diff)
    |> limit(^limit)
    |> Repo.all()
    |> Enum.map(fn al ->
      %{
        listens: al.listens,
        album: get_album!(al.id)
      }
    end)
  end

  def maybe_limit_by_time_diff(query, time_diff) do
    case time_diff do
      nil ->
        query

      _ ->
        time_ago = Timex.shift(DateTime.utc_now(), time_diff)
        where(query, [l], l.listened_at > ^time_ago)
    end
  end

  def group_by_track(limit \\ 9, time_diff \\ nil) do
    group_by_track_query()
    |> maybe_limit_by_time_diff(time_diff)
    |> limit(^limit)
    |> Repo.all()
  end

  def group_by_track_artist(artist) do
    group_by_track_query()
    |> where([l, a], artist_id: ^artist.id) 
    |> Repo.all()
  end

  def group_by_track_query() do
    Listen
    |> select([l], %{
      listens: fragment("count (?) as listens", l.id),
      track: l.track
    })
    |> group_by([l], [l.track])
    |> order_by(desc: fragment("listens"))
  end

  def list_artists do
    Repo.all(Artist)
  end

  def get_artist!(id), do: Repo.get!(Artist, id)

  def create_artist(attrs \\ %{}) do
    %Artist{}
    |> Artist.changeset(attrs)
    |> Repo.insert()
  end

  def update_artist(%Artist{} = artist, attrs) do
    artist
    |> Artist.changeset(attrs)
    |> Repo.update()
  end

  def delete_artist(%Artist{} = artist) do
    Repo.delete(artist)
  end

  def change_artist(%Artist{} = artist) do
    Artist.changeset(artist, %{})
  end

  alias Akedia.Listens.Album

  def list_albums do
    Album
    |> Repo.all()
    |> Repo.preload(:artist)
  end

  def list_albums_with_mbid_but_no_cover do
    query =
      from a in Album,
        where: not is_nil(a.mbid),
        where: is_nil(a.cover)

    query
    |> Repo.all()
    |> Repo.preload(:artist)
  end

  def get_album!(id) do
    Album
    |> Repo.get!(id)
    |> Repo.preload(:artist)
  end

  def create_album(attrs \\ %{}) do
    %Album{}
    |> Album.changeset(attrs)
    |> Repo.insert()
  end

  def update_album(%Album{} = album, attrs) do
    album
    |> Album.changeset(attrs)
    |> Repo.update()
  end

  def delete_album(%Album{} = album) do
    Repo.delete(album)
  end

  def has_cover?(id) do
    query =
      from a in Album,
        where: a.id == ^id,
        where: not is_nil(a.cover)

    Repo.exists?(query)
  end

  def change_album(%Album{} = album) do
    Album.changeset(album, %{})
  end
end
