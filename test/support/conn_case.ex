defmodule AkediaWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate
  import Plug.Conn, only: [fetch_session: 1, put_session: 3]
  import Akedia.Factory

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias AkediaWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint AkediaWeb.Endpoint
    end
  end

  def create_user() do
    insert(:user)
  end

  def create_session(conn, user) do
    conn
    |> fetch_session()
    |> put_session(:user_id, user.id)
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Akedia.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Akedia.Repo, {:shared, self()})
    end

    conn = Phoenix.ConnTest.build_conn()

    cond do
      tags[:signed_in] ->
        user = create_user()

        conn =
          conn
          |> create_session(user)

        {:ok, conn: conn, current_user: user}

      true ->
        {:ok, conn: conn}
    end
  end
end
