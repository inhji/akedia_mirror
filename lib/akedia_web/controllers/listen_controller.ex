defmodule AkediaWeb.ListenController do
  use AkediaWeb, :controller

  alias Akedia.Listens

  def index(conn, params) do
    page = Listens.listens_paginated(params)
    oldest_listen = Listens.get_oldest_listen()
    albums_weekly = Listens.group_by_album(5, weeks: -1)
    tracks_weekly = Listens.group_by_track(5, weeks: -1)

    render(conn, "index.html",
      page: page,
      listens: page.entries,
      oldest_listen: oldest_listen,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries,
      albums_weekly: albums_weekly,
      albums_max: get_max(albums_weekly),
      tracks_weekly: tracks_weekly,
      tracks_max: get_max(tracks_weekly)
    )
  end

  defp get_max(albums) do
    case List.first(albums) do
      nil -> 0
      albums -> Map.get(albums, :listens)
    end
  end
end
