defmodule Akedia.ActivityPub.Discovery do
  require Logger

  def fetch(url) do
    Logger.info("Fetching URL: #{url}")

    with {:ok, %HTTPoison.Response{body: body, status_code: 200}} <-
           Akedia.HTTP.get_json(url),
         {:ok, json} <- Jason.decode(body) do
      {:ok, json}
    else
      {:ok, %HTTPoison.Response{status_code: 410}} ->
        {:error, "User does not exist"}

      {:ok, %HTTPoison.Response{status_code: status}} ->
        {:error, "Server responded with #{status}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}

      {:error, %Jason.DecodeError{}} ->
        {:error, :json}

      e ->
        {:error, e}
    end
  end

  def discover_actor(url) do
    case fetch(url) do
      {:ok, %{"type" => "Person"} = json} ->
        {:ok, json}

      {:ok, %{"type" => "Note"} = json} ->
        discover_actor(json["attributedTo"])

      {:error, error} ->
        {:error, error}
    end
  end

  def discover_pub_key(url) do
    case discover_actor(url) do
      {:ok, json} ->
        pub_key =
          json
          |> Map.get("publicKey")
          |> Map.get("publicKeyPem")

        {:ok, pub_key}

      {:error, error} ->
        {:error, error}
    end
  end
end
