defmodule AkediaWeb.ListenController do
  use AkediaWeb, :controller

  alias Akedia.Listens

  def index(conn, _params) do
    listens = Listens.list()
    count = Listens.count()

    render(conn, "index.html", listens: listens, count: count)
  end
end
