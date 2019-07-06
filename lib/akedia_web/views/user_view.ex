defmodule AkediaWeb.UserView do
  use AkediaWeb, :view

  def render("meta.show.html", assigns) do
    [title("User", assigns)]
  end

  def render("meta.edit.html", assigns) do
    [title("Edit user", assigns)]
  end
end
