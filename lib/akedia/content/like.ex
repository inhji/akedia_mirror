defmodule Akedia.Content.Like do
  use Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Content.Entity

  schema "likes" do
    field :url, :string
    field :title, :string

    belongs_to :entity, Entity

    timestamps()
  end

  @doc false
  def changeset(like, attrs) do
    like
    |> cast(attrs, [:url, :title, :entity_id])
    |> validate_required([:url])
  end
end
