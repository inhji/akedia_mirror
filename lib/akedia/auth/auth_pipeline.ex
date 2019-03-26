defmodule Akedia.Auth.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :akedia

  plug Guardian.Plug.Pipeline, module: Akedia.Auth.Guardian,
                               error_handler: Akedia.Auth.AuthErrorHandler
  plug Guardian.Plug.EnsureAuthenticated
end
