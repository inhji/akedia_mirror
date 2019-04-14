defmodule Akedia.Accounts.Profile do
  use Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Accounts.User

  schema "profiles" do
    field :name, :string
    field :url, :string
    field :username, :string
    field :rel_value, :string, default: "me"

    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:name, :username, :url, :rel_value, :user_id])
    |> validate_required([:name, :url, :user_id])
  end
end
