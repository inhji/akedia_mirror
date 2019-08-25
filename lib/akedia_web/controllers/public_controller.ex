defmodule AkediaWeb.PublicController do
  use AkediaWeb, :controller

  plug :plug_onboard
  plug :plug_assigns

  def index(conn, params) do
    weather = Akedia.Workers.Weather.get_weather()

    options = [limit: 10, order_by: [desc: :inserted_at]]
    page = Akedia.Content.list_posts_paginated(options, params)

    render(conn, "index.html",
      weather: weather,
      page: page,
      posts: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
    )
  end

  def stream(conn, params) do
    page = Akedia.Content.list_entities_paginated(params)
    pinned = Akedia.Content.list_pinned_entities()

    render(conn, "stream.html",
      conn: conn,
      page: page,
      entities: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries,
      pinned: pinned
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
    last_listen = Akedia.Listens.listens(1)

    conn
    |> assign(:topics, topics)
    |> assign(:last_listen, last_listen)
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
