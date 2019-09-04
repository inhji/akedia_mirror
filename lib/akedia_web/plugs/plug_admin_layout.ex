defmodule AkediaWeb.Plugs.PlugAdminLayout do
  import Phoenix.Controller, only: [put_layout: 2]

  def admin_layout(conn, _) do
    put_layout(conn, {AkediaWeb.LayoutView, "admin.html"})
  end
end
