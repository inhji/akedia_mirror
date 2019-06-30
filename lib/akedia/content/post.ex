defmodule Akedia.Content.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Content.Entity
  alias Akedia.Slug

  @derive {Phoenix.Param, key: :slug}
  schema "posts" do
    field :content, :string
    field :slug, :string
    field :title, :string

    field :reply_to, :string

    belongs_to :entity, Entity

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :slug, :reply_to, :entity_id])
    |> validate_required([:content])
    |> Slug.maybe_generate_slug()
    |> unique_constraint(:slug)
  end
end
