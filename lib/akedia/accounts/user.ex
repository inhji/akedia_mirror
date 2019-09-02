defmodule Akedia.Accounts.User do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Accounts.{Credential, Profile}

  schema "users" do
    field :name, :string
    field :username, :string
    field :bio, :string, default: ""
    field :tagline, :string, default: ""
    field :avatar, Akedia.Media.AvatarUploader.Type
    field :cover, Akedia.Media.CoverUploader.Type

    has_one(:credential, Credential)
    has_many(:profiles, Profile)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username, :bio, :tagline])
    |> cast_attachments(attrs, [:avatar, :cover])
    |> validate_required([:name, :username])
    |> unique_constraint(:username)
  end
end
