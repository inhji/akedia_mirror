defmodule Akedia.Indie.Microformats do
  alias Akedia.HTTP

  def fetch(url) do
    case HTTP.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        html =
          body
          |> Floki.parse()
          |> Floki.raw_html()

        {:ok, Microformats2.parse(html, url)}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, :url_not_found}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def fetch_hcard(url) do
    with {:ok, %{:items => items}} <- fetch(url),
         {:ok, item} <- get_hcard(items),
         hcard <- item.properties do
      {:ok, hcard}
    else
      error -> error
    end
  end

  defp get_hcard(items) do
    case Enum.filter(items, &is_hcard?/1) do
      [] -> {:error, :hcard_not_found}
      _ -> {:ok, List.first(items)}
    end
  end

  defp is_hcard?(%{:type => ["h-card"]} = _item), do: true
  defp is_hcard?(_), do: false
end
