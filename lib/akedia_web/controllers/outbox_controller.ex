defmodule AkediaWeb.OutboxController do
  use AkediaWeb, :controller
  import Akedia.Helpers, only: [with_context: 1]

  def index(conn, _params) do
    json(
      conn,
      with_context(%{
        summary: "Outbox",
        type: "OrderedCollection",
        totalItems: 0,
        orderedItems: []
      })
    )
  end
end
