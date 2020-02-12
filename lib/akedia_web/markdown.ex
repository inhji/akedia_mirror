defmodule AkediaWeb.Markdown do
  @moduledoc """
  Defines common options for markdown rendering
  """

  @opts %Earmark.Options{
    footnotes: true,
    code_class_prefix: "language-",
    breaks: true
  }

  @doc """
  Renders the content of a post
  """
  def to_html(%{entity: _entity} = schema), do: to_html(schema.content)
  def to_html(nil), do: ""

  def to_html(markdown),
    do:
      markdown
      |> Earmark.as_html!(@opts)
      |> Phoenix.HTML.raw()

  def to_html!(nil), do: ""

  def to_html!(markdown) do
    {:safe, html} = to_html(markdown)
    html
  end
end
