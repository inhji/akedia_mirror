defmodule Akedia.Indie.Context do
  use Ecto.Schema
  use Waffle.Ecto.Schema
  import Ecto.Changeset

  schema "indie_contexts" do
    field :content, :string
    field :content_html, :string
    field :published_at, :naive_datetime
    field :url, :string
    field :photo, Akedia.Media.ContextUploader.Type

    belongs_to :author, Akedia.Indie.Author
    belongs_to :entity, Akedia.Content.Entity

    timestamps()
  end

  @doc false
  def changeset(context, attrs) do
    context
    |> cast(attrs, [:content, :content_html, :url, :published_at, :author_id, :entity_id])
    |> cast_attachments(attrs, [:photo], allow_paths: true)
    |> validate_required([:url, :published_at, :author_id, :entity_id])
  end
end
