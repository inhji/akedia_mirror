defmodule AkediaWeb.ListenController do
  use AkediaWeb, :controller

  alias Akedia.Listens

  def index(conn, _params) do
    listens = Listens.list()

    render(conn, "index.html", listens: listens)
  end

  def by_artist(conn, %{"last" => timespan}) do
    listens = case timespan do
      "hour" -> Listens.group_by_artist([hours: -1])
      "week" -> Listens.group_by_artist([weeks: -1])
      "month" -> Listens.group_by_artist([months: -1])
      "day" -> Listens.group_by_artist([days: -1])
      _ -> []
    end

    render(conn, "by_artist.html", listens: listens)
  end

  def by_artist(conn, %{}) do
    render(conn, "by_artist.html", listens: [])
  end
end
