defmodule Akedia.HTTP do
  @user_agent {"User-Agent", "Akedia/0.x (https://inhji.de)"}
  @options [follow_redirect: true]

  def get(url), do: HTTPoison.get(url, [@user_agent], @options)
  def get!(url), do: HTTPoison.get!(url, [@user_agent], @options)

  def head(url), do: HTTPoison.head(url, [@user_agent], @options)

  def user_agent(), do: @user_agent

  def scrape(url, selectors) do
    case get!(url) do
      %HTTPoison.Response{status_code: 200, body: body} ->
        values =
          Enum.map(selectors, fn {name, selector} ->
            value =
              body
              |> Floki.find(selector)
              |> Floki.text()
              |> IO.inspect()

            {name, value}
          end)

        {:ok, values}

      error ->
        error
    end
  end

  def hostname(url) do
    url_part(url, :host)
  end

  def scheme(url) do
    url_part(url, :scheme)
  end

  def url_part(url, part) do
    url
    |> URI.parse()
    |> Map.get(part)
  end

  def abs_url(relative_path) do
    cond do
      String.starts_with?(relative_path, "http") ->
        relative_path

      true ->
        abs_url(Akedia.url(), relative_path)
    end
  end

  def abs_url(base, relative_path) do
    base
    |> URI.parse()
    |> URI.merge(relative_path)
    |> to_string()
  end

  def base_url(url) do
    url_part(url, :scheme) <> "://" <> url_part(url, :host)
  end
end
