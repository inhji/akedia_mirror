defmodule Akedia.Auth.BrowserPipeline do
  use Guardian.Plug.Pipeline, otp_app: :akedia

  plug Guardian.Plug.Pipeline, module: Akedia.Auth.Guardian,
                               error_handler: Akedia.Auth.AuthErrorHandler
  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.LoadResource, allow_blank: true
end
