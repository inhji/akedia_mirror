defmodule AkediaWeb.AdminController do
  use AkediaWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
