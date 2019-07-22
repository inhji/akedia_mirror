defmodule AkediaWeb.LayoutView do
  use AkediaWeb, :view

  def version do
    Application.spec(:akedia, :vsn)
  end

  @doc """
  Tries to render a template named <name>.html or <name>.<template>.html
  For example: scripts.html or sidebar.index.html
  """
  def get_partial(name, assigns) do
    render_existing(assigns.view_module, name <> "." <> assigns.view_template, assigns) ||
      render_existing(assigns.view_module, name <> ".html", assigns)
  end

  def has_partial?(name, assigns) do
    !!get_partial(name, assigns)
  end
end
