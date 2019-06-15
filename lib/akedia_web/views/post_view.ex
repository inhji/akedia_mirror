defmodule AkediaWeb.PostView do
  use AkediaWeb, :view

  def render("meta.index.html", assigns) do
    [title("Posts", assigns)]
  end

  def render("scripts.edit.html", assigns), do: AkediaWeb.Helpers.Meta.admin_scripts(assigns)
  def render("scripts.new.html", assigns), do: AkediaWeb.Helpers.Meta.admin_scripts(assigns)
end
