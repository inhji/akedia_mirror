defmodule AkediaWeb.ListenController do
  use AkediaWeb, :controller

  alias Akedia.Listens

  def index(conn, params) do
    page = Listens.listens_paginated(params)
    albums_weekly = Listens.group_by_album(5, weeks: -1)
    albums_overall = Listens.group_by_album(5)

    render(conn, "index.html",
      page: page,
      listens: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries,
      albums_weekly: albums_weekly,
      max_weekly: get_max(albums_weekly),
      albums_overall: albums_overall,
      max_overall: get_max(albums_overall)
    )
  end

  defp get_max(albums) do
    case List.first(albums) do
      nil -> 0
      albums -> Map.get(albums, :listens)
    end
  end
end
