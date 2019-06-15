defmodule AkediaWeb.Helpers.Meta do
  import Phoenix.HTML, only: [sigil_E: 2]
  alias AkediaWeb.Router.Helpers, as: Routes

  def title(page_title, %{:site_title => site_title} = _assigns) do
    ~E{
      <title><%= page_title %> · <%= site_title %></title>
    }
  end

  def admin_scripts(assigns) do
    ~E{
      <script type="text/javascript" src="<%= Routes.static_path(@conn, "/js/admin.js") %>"></script>
    }
  end
end
