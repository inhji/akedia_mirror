defmodule AkediaWeb.LayoutView do
  use AkediaWeb, :view

  def version do
    Application.spec(:akedia, :vsn)
  end

  def canonical_url do
    Akedia.url()
  end
end
