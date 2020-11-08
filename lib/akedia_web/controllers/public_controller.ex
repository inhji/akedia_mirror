defmodule AkediaWeb.PublicController do
  use AkediaWeb, :controller

  plug :plug_onboard

  def plug_onboard(conn, _opts) do
    if conn.assigns.has_user do
      conn
    else
      redirect(conn, to: Routes.user_path(conn, :new))
    end
  end

  def index(conn, params) do
    page = Akedia.Content.list_posts_paginated([is_published: true], params)

    data = [
      tags: [],
      page: page,
      posts: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
    ]

    render(conn, "index.html", data)
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

  def post_type_filter(entity) do
    !!entity.bookmark or !!entity.post or !!entity.like
  end
end
