defmodule AkediaWeb.UserView do
  use AkediaWeb, :view

  def render("meta.show.html", _assigns) do
    ~E{
      <title>Profil</title>
    }
  end

  def render("meta.edit.html", _assigns) do
    ~E{
      <title>Profil bearbeiten</title>
    }
  end
end
