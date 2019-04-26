defmodule Akedia.Content.Like do
  use Ecto.Schema
  import Ecto.Changeset

  schema "likes" do
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(like, attrs) do
    like
    |> cast(attrs, [:url])
    |> validate_required([:url])
  end
end
