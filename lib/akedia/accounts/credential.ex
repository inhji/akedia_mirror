defmodule Akedia.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Accounts.User

  schema "credentials" do
    field :email, :string
    field :encrypted_password, :string

    field :device_name, :string
    field :external_id, :string
    field :public_key, :string

    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [
      :email,
      :encrypted_password,
      :user_id,
      :device_name,
      :external_id,
      :public_key
    ])
    |> validate_required([:email, :encrypted_password, :user_id])
    |> unique_constraint(:email)
    |> update_change(:encrypted_password, &Bcrypt.hash_pwd_salt/1)
  end
end
