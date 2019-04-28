defmodule Akedia.Content.Like do
  use Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Entity

  schema "likes" do
    field :url, :string

    belongs_to :entity, Entity

    timestamps()
  end

  @doc false
  def changeset(like, attrs) do
    like
    |> cast(attrs, [:url])
    |> validate_required([:url])
  end
end
