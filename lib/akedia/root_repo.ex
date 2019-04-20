defmodule Akedia.RootRepo do
  use Ecto.Repo,
    otp_app: :akedia,
    adapter: Ecto.Adapters.Postgres
end
