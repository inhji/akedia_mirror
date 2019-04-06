defmodule AkediaWeb.SessionView do
  use AkediaWeb, :view

  def render("meta.new.html", _assigns) do
    ~E{
      <title>Login · Akedia</title>
    }
  end
end
