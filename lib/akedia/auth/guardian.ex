defmodule Akedia.Auth.Guardian do
  use Guardian, otp_app: :akedia
  alias Akedia.Accounts

  def subject_for_token(user, _claims) do
    subject = to_string(user.id)
    {:ok, subject}
  end

  def resource_from_claims(%{"sub" => id}) do
    user = Accounts.get_user!(id)
    {:ok, user}
  end
end
