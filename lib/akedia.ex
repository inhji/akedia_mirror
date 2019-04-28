defmodule Akedia do
  @moduledoc """
  Akedia keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias AkediaWeb.{Router, Endpoint}

  def url do
    url(System.get_env("HOST") || Router.Helpers.url(Endpoint))
  end

  def url(url) do
    url
    |> URI.parse()
    |> to_string()
    |> String.trim_trailing("/")
  end
end
