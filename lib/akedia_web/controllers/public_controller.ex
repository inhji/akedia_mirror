defmodule AkediaWeb.PublicController do
  use AkediaWeb, :controller

  def index(conn, _params) do
    entities =
      Akedia.Content.list_entities()
      |> Enum.filter(fn entity ->
        !!entity.bookmark or !!entity.post or !!entity.like
      end)

    render(conn, "index.html", conn: conn, entities: entities)
  end
end
