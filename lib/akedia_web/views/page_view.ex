defmodule AkediaWeb.PageView do
  use AkediaWeb, :view

  def render("meta.index.html", assigns) do
    [title("Wiki", assigns)]
  end

  def render("meta.show.html", assigns) do
    [title(assigns.page.title, assigns)]
  end

  def render("scripts.edit.html", assigns), do: AkediaWeb.Helpers.Meta.admin_scripts(assigns)
  def render("scripts.new.html", assigns), do: AkediaWeb.Helpers.Meta.admin_scripts(assigns)

  def pinned_class(page) do
    case page.entity.is_pinned do
      true -> "pinned"
      false -> ""
    end
  end
end
