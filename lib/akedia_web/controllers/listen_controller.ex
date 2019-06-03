defmodule AkediaWeb.ListenController do
  use AkediaWeb, :controller

  alias Akedia.Listens

  def index(conn, _params) do
    listens = Listens.list()
    count = Listens.count()

    render(conn, "index.html", listens: listens, count: count)
  end

  # def artist(conn, %{"artist" => artist}) do
  #   listens = Listens.group_by_track(artist)
  #
  #   render(conn, "artist.html", listens: listens, artist: artist)
  # end

  def artists(conn, %{"last" => timespan}) do
    listens = case timespan do
      "hour" -> Listens.group_by_artist([hours: -1])
      "week" -> Listens.group_by_artist([weeks: -1])
      "month" -> Listens.group_by_artist([months: -1])
      "day" -> Listens.group_by_artist([days: -1])
      _ -> []
    end

    max_value =
      listens
      |> Enum.max_by(fn l -> l.listens end)
      |> Map.get(:listens)

    render(conn, "artists.html", listens: listens, max: max_value)
  end
end
