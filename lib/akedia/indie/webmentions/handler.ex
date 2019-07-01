defmodule Akedia.Indie.Webmentions.Handler do
  @behaviour Akedia.Plugs.PlugWebmention.HandlerBehaviour

  @impl true
  def handle_receive(body) do
    IO.inspect(body)

    :ok
  end
end
