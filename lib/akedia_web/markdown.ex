defmodule AkediaWeb.Markdown do
  @opts %Earmark.Options{
    footnotes: true,
    code_class_prefix: "language-",
    breaks: true
  }

  @custom_emoji [
    {":D", ":grin:"},
    {"xD", ":laughing:"},
    {":'D", ":sweat_smile:"}
  ]

  def to_html(nil), do: ""
  def to_html(%{entity: _entity} = schema), do: to_html(schema.content)

  def to_html(markdown) do
    markdown
    |> replace_custom_emoji()
    |> Emojix.replace_by_html()
    |> Earmark.as_html!(@opts)
    |> Phoenix.HTML.raw()
  end

  def to_html!(nil), do: ""

  def to_html!(markdown) do
    {:safe, html} = to_html(markdown)
    html
  end

  defp replace_custom_emoji(markdown) do
    Enum.reduce(@custom_emoji, markdown, fn {key, value}, result ->
      String.replace(result, to_string(key), value)
    end)
  end
end
