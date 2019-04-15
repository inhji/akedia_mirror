defmodule Akedia do
  @moduledoc """
  Akedia keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias AkediaWeb.{Router, Endpoint}

  def url do
    Router.Helpers.url(Endpoint)
    |> URI.parse()
    |> to_string()
  end
end
