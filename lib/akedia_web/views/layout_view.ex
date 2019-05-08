defmodule AkediaWeb.LayoutView do
  use AkediaWeb, :view

  def version do
    Application.spec(:akedia, :vsn)
  end
end
