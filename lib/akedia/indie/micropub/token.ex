defmodule Akedia.Indie.Micropub.Token do
  alias Akedia.Accounts
  require Logger

  @supported_scopes ["create", "update", "delete", "undelete", "media"]

  def verify_token(access_token, required_scope) do
    %{url: token_endpoint} = Accounts.get_profile_by_rel_value("token_endpoint")
    headers = [authorization: "Bearer #{access_token}", accept: "application/json"]

    Logger.info("Token endpoint: #{token_endpoint}")

    case HTTPoison.get(token_endpoint, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, body} ->
            verify_token_response(body, required_scope)

          error ->
            Logger.error("Could not decode response body", [error: error])
            {:error, :insufficient_scope, "Body of token response contains malformed json"}
        end

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("Could not reach token endpoint", [reason: reason])
        {:error, :insufficient_scope, reason}
    end
  end

  def verify_token_response(
        %{
          "me" => hostname,
          "scope" => scope,
          "client_id" => client_id,
          "issued_at" => _issued_at,
          "issued_by" => _issued_by,
          "nonce" => _nonce
        },
        required_scope
      ) do
    Logger.info("Hostname: '#{hostname}'")
    Logger.info("ClientId: #{client_id}")
    Logger.info("Scopes: '#{scope}'")

    with {:ok, _hostname} <- check_hostname(hostname),
         {:ok, _scope} <- check_scope(scope, required_scope) do
      :ok
    else
      error ->
        Logger.error("Could not verify token response", [error: error])
        error
    end
  end

  def sanitize_hostname(hostname) do
    String.trim_trailing(hostname, "/")
  end

  def check_hostname(hostname) do
    hostnames_match? = sanitize_hostname(hostname) == Akedia.url()

    case hostnames_match? do
      true ->
        {:ok, hostname}

      _ ->
        Logger.warn("Hostnames do not match: Given #{hostname}, Actual: #{Akedia.url()}")
        {:error, :insufficient_scope, "hostname does not match"}
    end
  end

  def check_scope(_, nil), do: :ok

  def check_scope(scopes, required_scope) do
    required = Enum.member?(@supported_scopes, required_scope)
    requested = Enum.member?(String.split(scopes), required_scope)

    cond do
      required && requested ->
        {:ok, scopes}

      !required ->
        {:error, :insufficient_scope, "scope '#{required_scope}' is not supported"}

      !requested ->
        {:error, :insufficient_scope, "scope '#{required_scope}' was not requested"}
    end
  end
end
