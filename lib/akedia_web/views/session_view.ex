defmodule AkediaWeb.SessionView do
  use AkediaWeb, :view

  def render("meta.new.html", assigns) do
    [title("Login", assigns)]
  end
end
