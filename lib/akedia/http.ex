defmodule Akedia.HTTP do
  @user_agent {"User-Agent", "Akedia/0.x (https://inhji.de)"}
  @options [follow_redirect: true]

  def get(url), do: HTTPoison.get(url, [@user_agent], @options)

  def head(url), do: HTTPoison.head(url, [@user_agent], @options)

  def user_agent(), do: @user_agent

  def hostname(url) do
    url
    |> URI.parse()
    |> Map.get(:host)
  end

  def abs_url(base, relative_path) do
    base
    |> URI.parse()
    |> URI.merge(relative_path)
    |> to_string()
  end
end
