defmodule Akedia.Scraper do
  @doc """
  Scrapes an url for a selector and returns its text value
  """
  @spec scrape(String.t(), [String.t()]) :: {:ok, [String.t()]} | map
  def scrape(url, selectors) do
    case Akedia.HTTP.get!(url) do
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
