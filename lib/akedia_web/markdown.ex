defmodule AkediaWeb.Markdown do
  alias Earmark.Options

  @opts %Options{
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
    {blocks, context} = Earmark.parse(markdown, @opts)

    blocks
    |> replace_shortcodes()
    |> render_markdown!(context)
    |> Phoenix.HTML.raw()
  end

  def to_html!(nil), do: ""

  def to_html!(markdown) do
    {:safe, html} = to_html(markdown)
    html
  end

  def render_markdown!(blocks, context) do
    {_, html} = context.options.renderer.render(blocks, context)
    html
  end

  def replace_shortcodes(blocks) do
    blocks
    |> Enum.map(fn block ->
      case block do
        %{blocks: blocks} ->
          %{block | blocks: replace_shortcodes(blocks)}

        %{lines: lines} ->
          %{block | lines: Enum.map(lines, &replace_shortcode/1)}

        _ ->
          block
      end
    end)
  end

  def replace_shortcode(line) do
    line
    |> String.replace(":done:", "👍")
  end
end
