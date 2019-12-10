defmodule Akedia.Indie.Token do
  require Logger
  alias HTTPoison.Response

  def verify(access_token, required_scope, token_endpoint) do
    headers = [authorization: "Bearer #{access_token}", accept: "application/json"]

    with {:ok, %Response{status_code: 200, body: body}} <-
           HTTPoison.get(token_endpoint, headers),
         {:ok, body_map} <- Jason.decode(body),
         :ok <- verify_token_response(body_map, required_scope) do
      :ok
    else
      {:error, %HTTPoison.Response{status_code: code}} ->
        Logger.error("Token endpoint responded with unexpected code: #{inspect(code)}")

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error("Could not reach token endpoint: #{inspect(reason)}")
        {:error, :insufficient_scope, reason}

      {:error, name, reason} ->
        Logger.error("Error #{reason} in #{name}")
        {:error, :insufficient_scope, reason}

      error ->
        Logger.error("Unexpected error: #{inspect(error)}")
        {:error, :insufficient_scope, "Internal Server Error"}
    end
  end

  defp verify_token_response(
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

    supported_scopes = Akedia.Indie.config(:supported_scopes, [])

    with {:ok, _hostname} <- verify_hostname_match(hostname),
         {:ok, _scope} <- verify_scope_support(scope, required_scope, supported_scopes) do
      :ok
    else
      {:error, name, reason} ->
        Logger.error("Could not verify token response: #{reason}")
        {:error, name, reason}
    end
  end

  defp verify_hostname_match(hostname) do
    hostnames_match? = Akedia.HTTP.sanitize_hostname(hostname) == Akedia.url()

    case hostnames_match? do
      true ->
        {:ok, hostname}

      _ ->
        Logger.warn("Hostnames do not match: Given #{hostname}, Actual: #{Akedia.url()}")
        {:error, "verify_hostname_match", "hostname does not match"}
    end
  end

  defp verify_scope_support(scopes, nil, _supported_scopes), do: {:ok, scopes}

  defp verify_scope_support(scopes, required_scope, supported_scopes) do
    required = Enum.member?(supported_scopes, required_scope)
    requested = Enum.member?(String.split(scopes), required_scope)

    cond do
      required && requested ->
        {:ok, scopes}

      !required ->
        {:error, "verify_scope_support", "scope '#{required_scope}' is not supported"}

      !requested ->
        {:error, "verify_scope_support", "scope '#{required_scope}' was not requested"}
    end
  end
end
