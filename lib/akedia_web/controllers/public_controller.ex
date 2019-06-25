defmodule AkediaWeb.PublicController do
  use AkediaWeb, :controller

  def index(conn, params) do
    page = Akedia.Content.list_entities(params)
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

    render(conn, "tagged.html", conn: conn, topic: topic, entities: entities)
  end

  def post_type_filter(entity) do
    !!entity.bookmark or !!entity.post or !!entity.like
  end
end
