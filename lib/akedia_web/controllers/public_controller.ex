defmodule AkediaWeb.PublicController do
  use AkediaWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
