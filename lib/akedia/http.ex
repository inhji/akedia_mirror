defmodule Akedia.HTTP do
  @moduledoc """
  Wrapper around HTTPoison that sets some sane defaults for akedia, currently:

  * Custom User-Agent
  * Following redirects

  Also contains a `scrape/2` function to scrape selector values from an url.

  """
  use HTTPoison.Base

  @accept_json {"Accept", "application/ld+json,application/activity+json"}
  @options [follow_redirect: true]

  @doc false
  def process_request_headers(headers), do: headers ++ [Akedia.user_agent()]

  @doc false
  def process_request_options(options), do: options ++ @options

  @doc """
  Sends an Accept header for activitypub
  """
  def get_json(url), do: get(url, [Akedia.user_agent(), @accept_json], @options)

  @doc """
  Scrapes an url for a selector and returns its text value
  """
  @spec scrape(String.t(), [String.t()]) :: {:ok, [String.t()]} | map
  def scrape(url, selectors) do
    case get!(url) do
      %HTTPoison.Response{status_code: 200, body: body} ->
        values =
          Enum.map(selectors, fn {name, selector} ->
            value =
              body
              |> Floki.parse_document()
              |> Floki.find(selector)
              |> List.first()
              |> Floki.text()

            {name, value}
          end)

        {:ok, values}

      error ->
        error
    end
  end
end
