defmodule Akedia.Content.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Akedia.Content.Entity

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
    |> cast(attrs, [:title, :content, :slug, :entity_id])
    |> validate_required([:content])
    |> maybe_generate_slug()
    |> unique_constraint(:slug)
  end

  def maybe_generate_slug(changeset) do
    with true <- changeset.valid?,
         nil <- get_field(changeset, :slug) do
      slug_base = get_slug_base(changeset)
      do_create_slug(changeset, slug_base)
    else
      _ -> changeset
    end
  end

  def get_slug_base(changeset) do
    case get_field(changeset, :title) do
      nil ->
        changeset
        |> get_field(:content)
        |> String.slice(0..15)
        |> String.downcase()

      title ->
        title
    end
  end

  def do_create_slug(changeset, string) do
    changeset
    |> put_change(:slug, Akedia.Helpers.unique_slug(string))
  end
end
