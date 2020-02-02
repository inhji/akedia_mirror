defmodule AkediaWeb.Helpers.Meta do
  import Phoenix.HTML, only: [sigil_E: 2]
  alias AkediaWeb.Router.Helpers, as: Routes

  def site_title(), do: Akedia.Settings.get(:site_title)

  def title(page_title, _assigns) when is_binary(page_title) do
    ~E{
      <title><%= page_title %> · <%= site_title() %></title>
    }
  end

  def title(schema, assigns) when is_map(schema) do
    page_title =
      cond do
        Map.has_key?(schema, :title) -> schema.title
        Map.has_key?(schema, :content) -> String.slice(schema.content, 0, 20) <> "…"
        true -> "Untitled"
      end

    title(page_title, assigns)
  end

  def title(_page_title, assigns) do
    title(assigns)
  end

  def title(_assigns) do
    ~E{
      <title><%= site_title() %></title>
    }
  end
end
