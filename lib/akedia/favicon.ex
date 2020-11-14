defmodule Akedia.Favicon do
  @moduledoc """
  Fetches the favicon for a url by looking at meta tags and favicon.ico
  """

  def fetch(url) do
    uri = URI.parse(url)
    domain = "#{uri.scheme}://#{uri.host}"

    case Akedia.HTTP.get(domain) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        find_favicon_url(domain, body)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, :url_not_found}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp find_favicon_in_root(domain) do
    favicon_url = "#{domain}/favicon.ico"

    case Akedia.HTTP.head(favicon_url) do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        {:ok, favicon_url}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, :favicon_not_found}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp find_favicon_url(domain, body) do
    if tag = find_favicon_link_tag(body) do
      {"link", attrs, _} = tag

      {"href", path} =
        Enum.find(attrs, fn {name, _} ->
          name == "href"
        end)

      {:ok, Akedia.Helpers.format_url(domain, path)}
    else
      find_favicon_in_root(domain)
    end
  end

  defp find_favicon_link_tag(html) do
    links =
      html
      |> Floki.parse_document()
      |> Floki.find("link")

    Enum.find(links, fn {"link", attrs, _} ->
      Enum.any?(attrs, fn {name, value} ->
        name == "rel" && String.contains?(value, "icon") && !String.contains?(value, "-icon-")
      end)
    end)
  end
end
