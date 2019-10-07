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
    |> Repo.all()
  end

  def listens_per_month_by_artist(artist_id) do
    Listen
    |> select([l], [count(l.id), fragment("date_trunc('month', ?) as month", l.listened_at)])
    |> order_by([l], fragment("date_trunc('month', ?)", l.listened_at))
    |> group_by([l], fragment("date_trunc('month', ?)", l.listened_at))
    |> where([l], l.artist_id == ^artist_id)
    |> Repo.all()
  end

  def listens_per_month_by_album(album_id) do
    Listen
    |> select([l], [count(l.id), fragment("date_trunc('month', ?) as month", l.listened_at)])
    |> order_by([l], fragment("date_trunc('month', ?)", l.listened_at))
    |> group_by([l], fragment("date_trunc('month', ?)", l.listened_at))
    |> where([l], l.album_id == ^album_id)
    |> Repo.all()
  end

  def listens_per_month() do
    time_ago = Timex.shift(DateTime.utc_now(), years: -1)

    Listen
    |> select([l], [count(l.id), fragment("date_trunc('month', ?) as month", l.listened_at)])
    |> order_by([l], fragment("month"))
    |> group_by([l], fragment("month"))
    |> where([l], l.listened_at > ^time_ago)
    |> Repo.all()
  end

  def get_oldest_listen() do
    Listen
    |> order_by(asc: :listened_at)
    |> limit(1)
    |> Repo.one!()
  end

  def get_newest_listen() do
    Listen
    |> order_by(desc: :listened_at)
    |> limit(1)
    |> Repo.one!()
  end

  def group_by_artist(limit \\ 9, time_diff \\ nil) do
    group_by_artist_query(limit, time_diff)
    |> Repo.all()
    |> Enum.map(fn artist ->
      %{
        listens: artist.listens,
        artist: get_artist!(artist.id)
      }
    end)
  end

  def group_by_artist_query(limit, time_diff) do
    Listen
    |> join(:left, [l], a in Artist, on: l.artist_id == a.id)
    |> group_by([l, a], a.id)
    |> maybe_limit_by_time_diff(time_diff)
    |> select([listen, artist], %{
      listens: fragment("count (?) as listens", listen.id),
      id: artist.id
    })
    |> limit(^limit)
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
    |> Enum.map(fn track ->
      %{
        track: track.track,
        listens: track.listens,
        album: get_album!(track.album_id)
      }
    end)
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
      track: l.track,
      album_id: l.album_id
    })
    |> group_by([l], [l.track, l.album_id])
    |> order_by(desc: fragment("listens"))
  end

  def list_artists do
    Repo.all(Artist)
  end

  def get_artist!(id) do
    Artist
    |> Repo.get!(id)
    |> Repo.preload(:listens)
  end

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
