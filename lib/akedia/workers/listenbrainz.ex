defmodule Akedia.Workers.Listenbrainz do
  use Que.Worker
  import Ecto.Query
  alias HTTPoison.Response
  alias Akedia.Content.Listen
  alias Akedia.Repo

  def perform(user) do
    fetch_listens(user)
    |> Enum.map(&prepare_listen/1)
    |> Enum.each(&Repo.insert/1)
  end

  def fetch_listens(user) do
    min_ts = last_listen_timestamp()

    case HTTPoison.get!("https://api.listenbrainz.org/1/user/#{user}/listens?min_ts=#{min_ts}") do
      %Response{body: body} ->
        body
        |> Jason.decode!(keys: :atoms)
        |> IO.inspect()
        |> Map.get(:payload)
        |> Map.get(:listens)

      _ ->
        nil
    end
  end

  def last_listen_timestamp do
    last_listen =
      Repo.one(
        from l in Listen,
          order_by: [desc: l.listened_at],
          limit: 1
      )

    case last_listen do
      nil ->
        0

      listen ->
        listen.listened_at
        |> DateTime.to_unix()
    end
  end

  def prepare_listen(listen) do
    Listen.changeset(%Listen{}, %{
      track: listen.track_metadata.track_name,
      album: listen.track_metadata.release_name,
      artist: listen.track_metadata.artist_name,
      listened_at: DateTime.from_unix!(listen.listened_at)
    })
  end
end
