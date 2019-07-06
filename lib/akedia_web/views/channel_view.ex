defmodule AkediaWeb.ChannelView do
  use AkediaWeb, :view

  def render("meta.index.html", assigns) do
    [title("Channels", assigns)]
  end

  def render("meta.show.html", assigns) do
    [title(assigns.channel.name, assigns)]
  end

  def render("meta.edit.html", assigns) do
    [title("Edit '#{assigns.channel.name}'", assigns)]
  end
end
