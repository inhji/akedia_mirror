defmodule Akedia.Indie.Author do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  schema "indie_authors" do
    field :name, :string
    field :photo, Akedia.Media.AuthorUploader.Type
    field :url, :string
    field :type, :string, default: "card"

    has_many :mentions, Akedia.Mentions.Mention
    has_many :contexts, Akedia.Indie.Context

    timestamps()
  end

  @doc false
  def changeset(author, attrs) do
    author
    |> cast(attrs, [:name, :type, :url])
    |> cast_attachments(attrs, [:photo], allow_paths: true)
    |> validate_required([:name, :url])
  end
end
