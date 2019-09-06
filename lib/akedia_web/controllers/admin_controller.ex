defmodule AkediaWeb.AdminController do
  use AkediaWeb, :controller

  def index(conn, _params) do
    weather = Akedia.Workers.Weather.get_weather()

    render(conn, "index.html", weather: weather)
  end

  def webauthn(conn, _params) do
    user = Akedia.Accounts.get_user!()
    credential = Akedia.Accounts.get_credential_by_user(user.id)

    render(conn, "webauthn.html", credential: credential)
  end
end
