defmodule AkediaWeb.ListenController do
  use AkediaWeb, :controller

  alias Akedia.Listens

  def by_artist(conn, %{"by" => "months"}) do
    listens = Listens.group_by_artist([months: -1])

    render(conn, "by_artist.html", listens: listens)
  end

  def by_artist(conn, %{"by" => "weeks"}) do
    listens = Listens.group_by_artist([weeks: -1])

    render(conn, "by_artist.html", listens: listens)
  end

  def by_artist(conn, %{"by" => "days"}) do
    listens = Listens.group_by_artist([days: -1])

    render(conn, "by_artist.html", listens: listens)
  end

  def by_artist(conn, %{"by" => "hours"}) do
    listens = Listens.group_by_artist([hours: -1])

    render(conn, "by_artist.html", listens: listens)
  end

  def by_artist(conn, _params) do
    listens = Listens.group_by_artist([weeks: -1])

    render(conn, "by_artist.html", listens: listens)
  end
end
