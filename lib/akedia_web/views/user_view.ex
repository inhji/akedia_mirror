defmodule AkediaWeb.UserView do
  use AkediaWeb, :view

  def render("meta.show.html", _assigns) do
    ~E{
      <title>Profile</title>
    }
  end
end
