defmodule AkediaWeb.ActorController do
  use AkediaWeb, :controller

  plug :accepts, ~w(json jsonap jsonld) when :action in [:index]

  def index(conn, _params) do
    user = Akedia.Accounts.get_user!()
    json(conn, Akedia.Accounts.User.to_json(user))
  end
end
