defmodule Akedia.Microformats2 do
  def parse(url) do
    case HTTPoison.get(url, follow_redirects: true) do
      {:ok, %{status_code: 200, body: body}} ->
        parse(body, url)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, :url_not_found}

      {:ok, %HTTPoison.Response{status_code: code}} ->
        {:error, code}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def parse(content, url) when is_binary(content), do: parse(Floki.parse_document(content), url)

  def parse(content, url) do
    doc =
      content
      |> Floki.filter_out("template")
      |> Floki.filter_out("style")
      |> Floki.filter_out("script")
      |> Floki.filter_out(:comment)

    rels = Akedia.Microformats2.Rels.parse(doc, url)
    items = Akedia.Microformats2.Items.parse(doc, doc, url)

    %{items: items, rels: rels[:rels], rel_urls: rels[:rel_urls]}
  end
end
