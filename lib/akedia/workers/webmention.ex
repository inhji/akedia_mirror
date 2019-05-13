defmodule Akedia.Workers.Webmention do
  use Que.Worker
  require Logger
  alias Akedia.Content.Like
  alias Akedia.Indie.Webmentions.Bridgy

  def perform(%Like{:entity_id => entity_id} = like) do
    url = Akedia.url(like)

    if should_syndicate_to_github?(like) do
      Akedia.Indie.create_or_update_syndication(%{
        type: "github",
        entity_id: entity_id
      })

      Bridgy.publish_to_github(like)
    end

    case Webmentions.send_webmentions(url, ".h-entry .title") do
      {:ok, results} ->
        Logger.debug("Send webmentions to #{Enum.count(results)} endpoints")

        # TODO: handle results better
        results
        |> Enum.each(fn {_status, _url, _endpoint, _text} = result ->
          Logger.info(inspect(result))
        end)

      {:error, error} ->
        Logger.error(error)
    end

    :ok
  end

  def should_syndicate_to_github?(%Like{:url => url}) do
    String.starts_with?(url, "https://github.com/")
  end
end
