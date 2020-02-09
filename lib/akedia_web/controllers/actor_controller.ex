defmodule AkediaWeb.ActorController do
  use AkediaWeb, :controller
  alias Akedia.Accounts

  plug :accepts, ~w(json jsonap jsonld) when :action in [:index]

  def index(conn, _params) do
    user = Accounts.get_user!()
    json(conn, Accounts.User.to_json(user))
  end
end
