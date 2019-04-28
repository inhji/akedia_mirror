defmodule Akedia.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Accounts.{Credential, Profile}

  schema "users" do
    field :name, :string
    field :username, :string
    field :bio, :string, default: ""
    field :tagline, :string, default: ""

    has_one(:credential, Credential)
    has_many(:profiles, Profile)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username, :bio, :tagline])
    |> validate_required([:name, :username])
    |> unique_constraint(:username)
  end
end
