defmodule Akedia.Workers.Listenbrainz do
  use Que.Worker
  import Ecto.Query
  alias HTTPoison.Response
  alias Akedia.Listens.{Listen, Artist, Album}
  alias Akedia.Repo

  def perform(user) do
    user
    |> fetch_listens()
    |> Enum.map(&prepare_listen/1)
    |> Enum.filter(fn l -> !is_nil(l) end)
    |> Enum.each(&Repo.insert/1)
  end

  def maybe_create_artist(name) when is_nil(name), do: {:error, :error}

  def maybe_create_artist(name) do
    artist =
      case Repo.get_by(Artist, name: name) do
        nil ->
          %Artist{}
          |> Artist.changeset(%{name: name})
          |> Repo.insert!()

        artist ->
          artist
      end

    {:ok, artist}
  end

  # Create catch-all album when album name is empty
  # This seems to happen for some reason in the listenbrainz api
  def maybe_create_album(name, artist) when is_nil(name) do
    maybe_create_album("Unknown", artist)
  end

  def maybe_create_album(name, artist) do
    album =
      case Repo.get_by(Album, name: name) do
        nil ->
          %Album{}
          |> Album.changeset(%{name: name, artist_id: artist.id})
          |> Repo.insert!()

        album ->
          album
      end

    {:ok, album}
  end

  def fetch_listens(user) do
    min_ts = last_listen_timestamp()

    case HTTPoison.get!("https://api.listenbrainz.org/1/user/#{user}/listens?min_ts=#{min_ts}") do
      %Response{body: body} ->
        body
        |> Jason.decode!(keys: :atoms)
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
        # min_ts=0 does not return anything from listenbrainz
        1

      listen ->
        listen.listened_at
        |> DateTime.to_unix()
    end
  end

  def prepare_listen(listen) do
    with {:ok, artist} <- maybe_create_artist(listen.track_metadata.artist_name),
         {:ok, album} <- maybe_create_album(listen.track_metadata.release_name, artist) do
      Listen.changeset(%Listen{}, %{
        track: listen.track_metadata.track_name,
        album_id: album.id,
        artist_id: artist.id,
        listened_at: DateTime.from_unix!(listen.listened_at)
      })
    else
      _ -> nil
    end
  end
end
