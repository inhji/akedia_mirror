defmodule AkediaWeb.Helpers.Meta do
  import Phoenix.HTML, only: [sigil_E: 2]
  alias AkediaWeb.Router.Helpers, as: Routes

  def title(%{:site_title => site_title} = _assigns) do
    ~E{
      <title><%= site_title %></title>
    }
  end

  def title(page_title, %{:site_title => site_title} = _assigns) when is_binary(page_title) do
    ~E{
      <title><%= page_title %> · <%= site_title %></title>
    }
  end

  def title(schema, %{:site_title => _site_title} = assigns) when is_map(schema) do
    page_title = schema.title || String.slice(schema.content, 0, 20) <> "…"
    title(page_title, assigns)
  end

  def admin_scripts(assigns) do
    ~E{
      <script type="text/javascript" src="<%= Routes.static_path(@conn, "/js/admin.js") %>"></script>
    }
  end
end
