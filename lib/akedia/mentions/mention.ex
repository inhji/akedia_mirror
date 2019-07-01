defmodule Akedia.Mentions.Mention do
  use Ecto.Schema
  import Ecto.Changeset

  schema "mentions" do
    field :bookmark_of, :string
    field :content_html, :string
    field :content_plain, :string
    field :in_reply_to, :string
    field :like_of, :string
    field :published_at, :naive_datetime
    field :repost_of, :string
    field :source, :string
    field :target, :string
    field :title, :string
    field :url, :string
    field :wm_property, :string

    has_one :author, Akedia.Mentions.Author
    belongs_to :entity, Akedia.Content.Entity

    timestamps()
  end

  @doc false
  def changeset(mention, attrs) do
    mention
    |> cast(attrs, [
      :source,
      :target,
      :content_plain,
      :content_html,
      :title,
      :published_at,
      :url,
      :in_reply_to,
      :like_of,
      :repost_of,
      :bookmark_of,
      :wm_property,
      :author_id
    ])
    |> validate_required([
      :source,
      :target,
      :content_plain,
      :content_html,
      :title,
      :published_at,
      :url,
      :in_reply_to,
      :like_of,
      :repost_of,
      :bookmark_of,
      :wm_property,
      :author_id
    ])
  end
end
