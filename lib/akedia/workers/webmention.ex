defmodule Akedia.Workers.Webmention do
  use Que.Worker
  require Logger

  def perform(%Akedia.Content.Like{} = like) do
    url = Akedia.url(like)

    case Webmentions.send_webmentions(url, ".h-entry .title") do
      {:ok, results} ->
        Logger.debug("Send webmentions to #{Enum.count(results)} endpoints")

        # TODO: handle results better
        results
        |> Enum.each(fn {_status, _url, _endpoint, _text} = result ->
          Logger.debug(inspect(result))
        end)

      {:error, error} ->
        Logger.error(error)
    end

    :ok
  end
end
