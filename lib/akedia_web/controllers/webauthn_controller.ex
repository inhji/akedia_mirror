defmodule AkediaWeb.WebauthnController do
  use AkediaWeb, :controller

  alias Akedia.Accounts

  def create(conn, %{"device_name" => device_name}) do
    credential_options =
      WebAuthnEx.credential_creation_options("web-server", "localhost")
      |> Map.put(:user, %{
        id: device_name |> Base.encode64(),
        name: device_name,
        displayName: device_name
      })

    conn =
      conn
      |> put_session(:challenge, credential_options.challenge)

    challenge =
      credential_options.challenge
      |> Base.encode64()

    credential_options =
      credential_options
      |> Map.put(:challenge, challenge)

    json(conn, credential_options)
  end

  def callback(conn, %{"response" => response, "device_name" => device_name}) do
    {:ok, client_json} = response["clientDataJSON"] |> Base.decode64()
    {:ok, attestation_object} = response["attestationObject"] |> Base.decode64()

    challenge = get_session(conn, :challenge)

    result =
      WebAuthnEx.AuthAttestationResponse.new(
        challenge,
        Akedia.url(),
        attestation_object,
        client_json
      )

    conn =
      case result do
        {:ok, att_resp} ->
          {{:ECPoint, public_key}, {:namedCurve, :prime256v1}} = att_resp.credential.public_key

          credential_params = %{
            "device_name" => device_name,
            "external_id" => Base.encode64(att_resp.credential.id),
            "public_key" => Base.encode64(public_key)
          }

          # TODO: Update credentials for user
          user = Accounts.get_user!()
          credential = Accounts.get_credential_by_user(user.id)
          Accounts.update_credential(credential, credential_params)

          conn
          |> assign(:current_user, user)
          |> put_session(:user_id, user.id)
          |> configure_session(renew: true)

        {:error, _reason} ->
          conn
          |> put_status(:forbidden)
      end

    json(conn, %{})
  end
end
