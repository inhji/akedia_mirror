defmodule AkediaWeb.Markdown do
  alias Earmark.Options

  def to_html(%{entity: _entity} = content) do
    content.content
    |> to_html()
  end

  def to_html(markdown) do
    markdown
    |> Earmark.as_html!(%Options{})
  end
end
