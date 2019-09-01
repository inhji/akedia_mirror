import Plug.Conn, only: [assign: 3]

defmodule AkediaWeb.Plugs.PlugAssignSettings do
  def assign_settings(conn, _) do
    Akedia.Settings.get_all()
    |> Enum.reduce(conn, fn {key, value}, conn ->
      assign(conn, key, value)
    end)
  end
end
