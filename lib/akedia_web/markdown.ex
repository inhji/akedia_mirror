defmodule AkediaWeb.Markdown do
  @opts %Earmark.Options{
    footnotes: true,
    code_class_prefix: "language-",
    breaks: true
  }

  def to_html(nil), do: ""

  def to_html(%{entity: _entity} = content) do
    content.content
    |> to_html()
  end

  def to_html(markdown) do
    markdown
    |> Earmark.as_html!(@opts)
    |> Phoenix.HTML.raw()
  end

  def to_html!(nil), do: ""

  def to_html!(markdown) do
    {:safe, html} = to_html(markdown)
    html
  end
end
