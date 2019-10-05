defmodule AkediaWeb.PublicController do
  use AkediaWeb, :controller

  plug :plug_onboard
  plug :plug_assigns

  def index(conn, params) do
    weather = Akedia.Workers.Weather.get_weather()
    page = Akedia.Content.list_entities_paginated(params)

    render(conn, "index.html",
      weather: weather,
      page: page,
      entities: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
    )
  end

  def now(conn, _params) do
    render(conn, "now.html", [])
  end

  def about(conn, _params) do
    render(conn, "about.html", [])
  end

  def tagged(conn, %{"topic" => topic}) do
    topic = Akedia.Content.get_topic!(topic)

    entities =
      topic.entities
      |> Enum.filter(&post_type_filter/1)
      |> Enum.sort(fn f, s ->
        NaiveDateTime.diff(f.inserted_at, s.inserted_at) >= 0
      end)

    render(conn, "tagged.html",
      conn: conn,
      topic: topic,
      entities: entities
    )
  end

  def plug_assigns(conn, _opts) do
    topics = Akedia.Content.list_top_topics(15)
    pinned_topics = Akedia.Content.list_pinned_topics()
    last_listens = Akedia.Listens.listens(3)

    conn
    |> assign(:topics, topics)
    |> assign(:pinned_topics, pinned_topics)
    |> assign(:last_listens, last_listens)
  end

  def plug_onboard(conn, _opts) do
    if not conn.assigns.has_user do
      conn
      |> redirect(to: Routes.user_path(conn, :new))
    else
      conn
    end
  end

  def post_type_filter(entity) do
    !!entity.bookmark or !!entity.post or !!entity.like
  end
end
