defmodule Akedia.Indie.Webmentions do
  require Logger
  alias Akedia.HTTP

  def do_send_webmentions(url, selector) do
    case Webmentions.send_webmentions(url, selector) do
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
  end

  def send_webmentions(%{:entity_id => _entity_id} = schema) do
    url = Akedia.url(schema)

    # TODO: Finish this implementation?
    # Goal here is to see the full response in case of an error
    # To examine what brid.gy does, for example when trying to update
    # a github star/comment
  end

  def fetch_links(url, selector \\ "") do
    selector = String.trim(selector <> " a[href]")
    base_url = HTTP.base_url(url)

    html =
      case HTTP.get(url) do
        {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
          body

        {:ok, %HTTPoison.Response{status_code: code}} ->
          {:error, "Could not fetch url, got code #{code}"}

        {:error, error} ->
          {:error, error}
      end

    links =
      html
      |> Floki.parse()
      |> Floki.find(selector)
      |> Enum.map(&extract_href/1)
      |> Enum.filter(fn url -> url != "#" end)
      |> Enum.map(&Akedia.HTTP.abs_url(base_url, &1))

    {:ok, links}
  end

  def extract_href(node) do
    Floki.attribute(node, "a", "href")
    |> List.first()
  end
end
