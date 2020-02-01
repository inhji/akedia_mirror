defmodule AkediaWeb.QueueController do
  use AkediaWeb, :controller

  def index(conn, _params) do
    entities = Akedia.Content.list_queued_entities()

    render(conn, "index.html", entities: entities)
  end
end
