defmodule AkediaWeb.SearchController do
  use AkediaWeb, :controller
  alias Akedia.Content

  def search(conn, %{"query" => query}) do
    entities = Content.search(query)

    conn
    |> render("search.html", query: query, entities: entities)
  end
end
