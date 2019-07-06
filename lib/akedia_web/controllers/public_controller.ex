defmodule AkediaWeb.PublicController do
  use AkediaWeb, :controller

  plug :plug_onboard
  plug :plug_assigns

  def index(conn, params) do
    page = Akedia.Content.list_entities_paginated(params)
    pinned = Akedia.Content.list_pinned_entities()

    render(conn, "index.html",
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

  def tagged(conn, %{"topic" => topic}) do
    topic = Akedia.Content.get_topic!(topic)
    entities = Enum.filter(topic.entities, &post_type_filter/1)

    render(conn, "tagged.html",
      conn: conn,
      topic: topic,
      entities: entities
    )
  end

  def plug_assigns(conn, _opts) do
    topics = Akedia.Content.list_topics(15)
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
