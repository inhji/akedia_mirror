import Plug.Conn, only: [assign: 3]

defmodule AkediaWeb.Plugs.Settings do
  def assign_settings(conn, _) do
    settings = Akedia.Settings.get_all()

    Enum.reduce(settings, conn, fn ({key, value}, conn) ->
      assign(conn, key, value)
    end)
  end
end
