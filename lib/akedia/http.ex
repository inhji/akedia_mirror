defmodule Akedia.HTTP do
  @moduledoc """
  Wrapper around HTTPoison that sets some sane defaults for akedia, currently:

  * Custom User-Agent
  * Following redirects
  """
  use HTTPoison.Base

  @accept_json {"Accept", "application/ld+json,application/activity+json"}
  @options [follow_redirect: true]

  @doc false
  def process_request_headers(headers),
    do: headers ++ [Akedia.user_agent()]

  @doc false
  def process_request_options(options),
    do: options ++ @options

  @doc """
  Sends an Accept header for activitypub
  """
  def get_json(url),
    do: get(url, [@accept_json])
end
