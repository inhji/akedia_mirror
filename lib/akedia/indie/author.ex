defmodule Akedia.Indie.Author do
  use Ecto.Schema
  import Ecto.Changeset

  schema "indie_authors" do
    field :name, :string
    field :photo, :string
    field :url, :string
    field :type, :string, default: "card"

    has_many :mentions, Akedia.Mentions.Mention
    has_many :contexts, Akedia.Indie.Context

    timestamps()
  end

  @doc false
  def changeset(author, attrs) do
    author
    |> cast(attrs, [:name, :photo, :type, :url])
    |> validate_required([:name, :url])
  end
end
