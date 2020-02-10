defmodule AkediaWeb.Plugs.PlugFormat do
  import Plug.Conn, only: [put_private: 3]
  import Phoenix.Controller, only: [get_format: 1]

  def put_req_format(conn, opts) do
    put_private(conn, :plug_format, get_format(conn))
  end
end
