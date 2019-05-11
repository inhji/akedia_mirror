defmodule AkediaWeb.Helpers.Content do
  import Phoenix.Controller, only: [render: 2, render: 3]

  def render_index_or_empty(conn, content, assigns \\ []) do
    case Enum.count(content) do
      0 -> render(conn, "empty.html")
      _ -> render(conn, "index.html", assigns)
    end
  end
end
