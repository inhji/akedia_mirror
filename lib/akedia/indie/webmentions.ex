defmodule Akedia.Indie.Webmentions do
  require Logger
  alias Akedia.HTTP

  # def do_send_webmentions(url, selector) do
  #   case Webmentions.send_webmentions(url, selector) do
  #     {:ok, results} ->
  #       Logger.debug("Sent webmentions to #{Enum.count(results)} endpoints")
  #
  #       # TODO: handle results better
  #       results
  #       |> Enum.each(fn {_status, _url, _endpoint, _text} = result ->
  #         Logger.info(inspect(result))
  #       end)
  #
  #     {:error, error} ->
  #       Logger.error(error)
  #   end
  # end

  def do_send_webmentions(source_url, selector \\ ".h-entry") do
    Logger.info("Sending webmentions for #{source_url}")

    case fetch_links(source_url, selector) do
      {:ok, links} ->
        results =
          Enum.reduce(
            links,
            %{},
            &send_and_handle_webmention(&1, &2, source_url)
          )

        {:ok, results}

      {:error, error} ->
        {:error, error}
    end

    # TODO: Finish this implementation?
    # Goal here is to see the full response in case of an error
    # To examine what brid.gy does, for example when trying to update
    # a github star/comment
  end

  def send_and_handle_webmention(target_url, result, source_url) do
    result_item =
      case IndieWeb.Webmention.send(target_url, source_url) do
        {:ok, response} ->
          %{
            status: response.status,
            body: response.body
          }

        {:error, :webmention_send_failure, info} ->
          Enum.into(info, %{status: :not_sent})

        {:error, error} ->
          %{error: error, status: :not_sent}
      end

    Map.put(result, target_url, result_item)
  end

  def fetch_links(url, selector) do
    selector = "#{selector} a[href]"
    base_url = HTTP.base_url(url)

    case fetch_html(url) do
      {:ok, body} ->
        links =
          body
          |> Floki.parse()
          |> Floki.find(selector)
          |> Enum.map(&extract_href/1)
          |> Enum.filter(fn url -> url != "#" end)
          |> Enum.map(&Akedia.HTTP.abs_url(base_url, &1))

        {:ok, links}

      {:error, error} ->
        Logger.error(error)
    end
  end

  def fetch_html(url) do
    case HTTP.get(url) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        {:ok, body}

      {:ok, %HTTPoison.Response{status_code: code}} ->
        {:error, "Could not fetch url, got code #{code}"}

      {:error, error} ->
        {:error, error}
    end
  end

  def extract_href(node) do
    node
    |> Floki.attribute("a", "href")
    |> List.first()
  end
end
