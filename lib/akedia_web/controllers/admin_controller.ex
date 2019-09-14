defmodule AkediaWeb.AdminController do
  use AkediaWeb, :controller

  def index(conn, _params) do
    weather = Akedia.Workers.Weather.get_weather()
    render(conn, "index.html", weather: weather)
  end

  def webauthn(conn, _params) do
    user = Akedia.Accounts.get_user!()
    credential = Akedia.Accounts.get_credential_by_user(user.id)

    render(conn, "webauthn.html", credential: credential)
  end

  def totp(conn, _params) do
    user = Akedia.Accounts.get_user!()
    issuer = user.username
    email = user.credential.email

    qr_code =
      Akedia.Settings.get(:totp_secret)
      |> Base.encode32()
      |> totp_qr_string(issuer, email)
      |> QRCode.QR.create!()
      |> QRCode.Svg.to_base64()

    render(conn, "totp.html", qr_code: qr_code)
  end

  defp totp_qr_string(secret, issuer, email) do
    "otpauth://totp/#{issuer}:#{email}?secret=#{secret}&issuer=#{issuer}&algorithm=SHA1&digits=6&period=30"
  end
end
