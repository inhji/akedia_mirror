defmodule Akedia.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Accounts.User

  schema "credentials" do
    field :email, :string
    field :encrypted_password, :string

    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:email, :encrypted_password, :user_id])
    |> validate_required([:email, :encrypted_password, :user_id])
    |> unique_constraint(:email)
    |> update_change(:encrypted_password, &Bcrypt.hash_pwd_salt/1)
  end
end
