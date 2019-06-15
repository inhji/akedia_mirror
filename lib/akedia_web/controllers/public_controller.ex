defmodule AkediaWeb.PublicController do
  use AkediaWeb, :controller

  def index(conn, _params) do
    entities =
      Akedia.Content.list_entities()
      |> Enum.filter(&post_type_filter/1)

    render(conn, "index.html", conn: conn, entities: entities)
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
