defmodule Akedia.Indie.Favicon do
  alias Akedia.HTTP

  def fetch(url) do
    uri = URI.parse(url)
    domain = "#{uri.scheme}://#{uri.host}"

    case HTTP.get(domain) do
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

    case HTTP.head(favicon_url) do
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

      {:ok, format_url(domain, path)}
    else
      find_favicon_in_root(domain)
    end
  end

  defp format_url(domain, path) do
    uri_domain_host = URI.parse(domain).host
    uri_path_host = URI.parse(path).host

    cond do
      # favicon is on another domain
      uri_domain_host && uri_path_host && uri_domain_host != uri_path_host ->
        append_scheme(domain, "#{path}")

      # the favicon is an absolute path (within the same domain)
      String.contains?(path, uri_domain_host) ->
        append_scheme(domain, "#{path}")

      # relative path starting with /
      String.starts_with?(path, "/") ->
        append_scheme(domain, "#{domain}#{path}")

      true ->
        append_scheme(domain, "#{domain}/#{path}")
    end
  end

  defp append_scheme(domain, favicon_url) do
    scheme = URI.parse(domain).scheme
    if String.starts_with?(favicon_url, "//"), do: "#{scheme}:#{favicon_url}", else: favicon_url
  end

  defp find_favicon_link_tag(html) do
    links = Floki.find(html, "link")

    Enum.find(links, fn {"link", attrs, _} ->
      Enum.any?(attrs, fn {name, value} ->
        name == "rel" && String.contains?(value, "icon") && !String.contains?(value, "-icon-")
      end)
    end)
  end
end
