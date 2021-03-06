defmodule Akedia.Helpers do
  @default_context ["https://www.w3.org/ns/activitystreams"]
  @context_name "@context"
  @format_string "{WDshort}, {0D} {Mshort} {YYYY} {h24}:{m}:{s} GMT"

  def with_context(%{} = object) do
    Map.put(object, @context_name, @default_context)
  end

  def with_context(%{} = object, extra_context) do
    new_context =
      if Map.has_key?(object, @context_name) do
        Map.get(object, @context_name) ++ extra_context
      else
        @default_context ++ extra_context
      end

    Map.put(object, @context_name, new_context)
  end

  def httpdate, do: DateTime.utc_now() |> Timex.format(@format_string)
  def httpdate(date), do: date |> Timex.format(@format_string)

  def sanitize_hostname(hostname), do: String.trim_trailing(hostname, "/")

  def abs_url(relative_path) do
    if String.starts_with?(relative_path, "http") do
      relative_path
    else
      abs_url(relative_path, Akedia.url())
    end
  end

  def abs_url(relative_path, base) do
    base
    |> URI.parse()
    |> URI.merge(relative_path)
    |> to_string()
  end

  def hostname(url), do: url_part(url, :host)
  def scheme(url), do: url_part(url, :scheme)

  def url_part(url, part) do
    url
    |> URI.parse()
    |> Map.get(part)
  end

  def format_url(domain, path) do
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

  def append_scheme(domain, favicon_url),
    do:
      if(String.starts_with?(favicon_url, "//"),
        do: "#{scheme(domain)}:#{favicon_url}",
        else: favicon_url
      )
end
