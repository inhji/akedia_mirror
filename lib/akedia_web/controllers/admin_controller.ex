defmodule AkediaWeb.AdminController do
  use AkediaWeb, :controller

  def index(conn, _params) do
    weather = Akedia.Workers.Weather.get_weather()

    render(conn, "index.html", weather: weather)
  end
end
