defmodule Akedia.Listens do
  import Ecto.Query, warn: false
  alias Akedia.Repo
  alias Akedia.Content.Listen

  def list(limit \\ 10) do
    Listen
    |> order_by(desc: :listened_at)
    |> limit(^limit)
    |> Repo.all()
  end

  def group_by_artist(time_diff) do
    Repo.all(group_by_artist_query(time_diff))
  end

  def group_by_track(artist) do
    Repo.all(group_by_track_query(artist))
  end

  def group_by_track_query(artist) do
    Listen
    |> select([l], %{
      listens: fragment("count (?) as listens", l.id),
      track: l.track
    })
    |> group_by([l], l.track)
    |> where(artist: ^artist)
    |> order_by(desc: fragment("listens"))
  end

  def group_by_artist_query(time_diff \\ [days: -7]) do
    time_ago = Timex.shift(DateTime.utc_now(), time_diff)

    Listen
    |> group_by([l], l.artist)
    |> select([listen], %{
      listens: fragment("count (?) as listens", listen.id),
      artist: listen.artist
    })
    |> where([l], l.listened_at > ^time_ago)
    |> order_by(desc: fragment("listens"))
  end
end
