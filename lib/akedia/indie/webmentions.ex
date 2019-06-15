defmodule Akedia.Indie.Webmentions do
  require Logger

  def do_send_webmentions(url, selector) do
    case Webmentions.send_webmentions(url, selector) do
      {:ok, results} ->
        Logger.debug("Sent webmentions to #{Enum.count(results)} endpoints")

        # TODO: handle results better
        results
        |> Enum.each(fn {_status, _url, _endpoint, _text} = result ->
          Logger.info(inspect(result))
        end)

      {:error, error} ->
        Logger.error(error)
    end
  end
end
