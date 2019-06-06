defmodule AkediaWeb.Helpers.Meta do
  import Phoenix.HTML, only: [sigil_E: 2]

  def title(page_title, %{:site_title => site_title} = _assigns) do
    ~E{
      <title><%= page_title %> · <%= site_title %></title>
    }
  end
end
