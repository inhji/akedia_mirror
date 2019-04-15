defmodule Akedia.Indie.Micropub.Token do
  alias Akedia.Accounts
  require Logger

  @supported_scopes ["create", "update", "delete", "undelete"]

  def verify_token(access_token, required_scope) do
    %{url: token_endpoint} = Accounts.get_profile_by_rel_value("token_endpoint")
    headers = [authorization: "Bearer #{access_token}", accept: "application/json"]

    Logger.debug("Token endpoint: #{token_endpoint}")

    case HTTPoison.get(token_endpoint, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, body} ->
            verify_token_response(body, required_scope)

          _ ->
            {:error, :insufficient_scope, "Body of token response contains malformed json"}
        end

      {:error, %HTTPoison.Error{reason: reason}} ->
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
    Logger.debug("Hostname: '#{hostname}'")
    Logger.debug("ClientId: #{client_id}")
    Logger.debug("Scopes: '#{scope}'")

    with {:ok, _hostname} <- check_hostname(hostname),
         {:ok, _scope} <- check_scope(scope, required_scope) do
      :ok
    else
      error -> error
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
        {:error, :insufficient_scope, "hostname does not match"}
    end
  end

  def check_scope(_, nil), do: :ok

  def check_scope(scopes, required_scope) do
    scopes_match? =
      [@supported_scopes, String.split(scopes)]
      |> Enum.all?(&Enum.member?(&1, required_scope))

    case scopes_match? do
      true ->
        {:ok, scopes}

      _ ->
        {:error, :insufficient_scope, "scopes do not match"}
    end
  end
end
