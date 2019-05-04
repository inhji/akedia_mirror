defmodule Akedia.Media.Favicon do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Media.FaviconUploader

  schema "favicons" do
    field :name, FaviconUploader.Type
    field :tld, :string

    timestamps()
  end

  @doc false
  def changeset(favicon, attrs) do
    favicon
    |> cast(attrs, [:tld])
    |> cast_attachments(attrs, [:name], allow_paths: true)
    |> validate_required([:tld])
  end
end
