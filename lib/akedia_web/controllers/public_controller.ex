defmodule AkediaWeb.PublicController do
  use AkediaWeb, :controller

  plug :plug_onboard

  def index(conn, params) do
    weather = Akedia.Workers.Weather.get_weather()
    page = Akedia.Content.list_entities_paginated(params)
    post_changeset = Akedia.Content.change_post(%Akedia.Content.Post{})
    topics = Akedia.Content.list_top_topics(15)

    data = [
      changeset: post_changeset,
      tags: [],
      weather: weather,
      topics: topics,
      page: page,
      entities: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
    ]

    render(conn, "index.html", data)
  end

  def queue(conn, _params) do
    entities = Akedia.Content.list_queued_entities()

    render(conn, "queue.html", entities: entities)
  end

  def now(conn, _params) do
    render(conn, "now.html", [])
  end

  def about(conn, _params) do
    render(conn, "about.html", [])
  end

  def search(conn, %{"query" => query}) do
    entities = Akedia.Content.search(query)
    render(conn, "search.html", query: query, entities: entities)
  end

  def tagged(conn, %{"topic" => topic}) do
    topic = Akedia.Content.get_topic!(topic)
    topics = Akedia.Content.list_top_topics(15)

    entities =
      topic.entities
      |> Enum.filter(&post_type_filter/1)
      |> Enum.sort(fn f, s ->
        NaiveDateTime.diff(f.inserted_at, s.inserted_at) >= 0
      end)

    render(conn, "tagged.html",
      conn: conn,
      topic: topic,
      entities: entities,
      topics: topics
    )
  end

  def plug_onboard(conn, _opts) do
    if conn.assigns.has_user do
      conn
    else
      redirect(conn, to: Routes.user_path(conn, :new))
    end
  end

  def post_type_filter(entity) do
    !!entity.bookmark or !!entity.post or !!entity.like
  end
end
