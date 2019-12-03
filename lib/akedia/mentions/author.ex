defmodule Akedia.Mentions.Author do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mention_authors" do
    field :name, :string
    field :photo, :string
    field :type, :string
    field :url, :string

    has_many :mentions, Akedia.Mentions.Mention

    timestamps()
  end

  @doc false
  def changeset(author, attrs) do
    author
    |> cast(attrs, [:name, :photo, :type, :url])
    |> validate_required([:name, :type, :url])
  end
end
