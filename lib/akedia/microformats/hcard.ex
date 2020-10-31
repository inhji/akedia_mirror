defmodule Akedia.Microformats2.Hcard do
  defstruct name: "", photo: ""

  def parse(%{:name => [name], :photo => [photo]} = properties) when is_map(properties) do
    {:ok,
     %Akedia.Microformats2.Hcard{
       name: name,
       photo: photo
     }}
  end

  def parse(_), do: {:error, :no_hcard_found}

  def fetch_hcard(url) do
    with %HTTPoison.Response{status_code: 200, body: body} <- Akedia.HTTP.get(url),
         %{items: items} <- Akedia.Microformats2.parse(body, url),
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
