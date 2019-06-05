defmodule Akedia.Listens do
  import Ecto.Query, warn: false
  alias Akedia.Repo
  alias Akedia.Listens.{Listen, Artist}

  def list(limit \\ 10) do
    Listen
    |> order_by(desc: :listened_at)
    |> limit(^limit)
    |> Repo.all()
    |> Repo.preload([:artist, :album])
  end

  def count() do
    Repo.one(from l in Listen, select: count("*"))
  end

  def group_by_artist(time_diff \\ nil) do
    group_by_artist_query(time_diff)
    |> Repo.all()
  end

  def group_by_artist_query(time_diff \\ nil) do
    query =
      Listen
      |> join(:left, [l], a in Artist, on: l.artist_id == a.id)
      |> group_by([l, a], a.name)
      |> select([listen, artist], %{
        listens: fragment("count (?) as listens", listen.id),
        artist: artist.name
      })
      |> order_by(desc: fragment("listens"))

    query =
      case time_diff do
        nil ->
          limit(query, 100)

        _ ->
          time_ago = Timex.shift(DateTime.utc_now(), time_diff)
          where(query, [l], l.listened_at > ^time_ago)
      end
  end

  def group_by_track(artist) do
    group_by_track_query(artist)
    |> Repo.all()
  end

  def group_by_track_query(artist) do
    Listen
    |> select([l], %{
      listens: fragment("count (?) as listens", l.id),
      track: l.track
    })
    |> group_by([l], l.track)
    |> where([l, a], artist_id: ^artist.id)
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
