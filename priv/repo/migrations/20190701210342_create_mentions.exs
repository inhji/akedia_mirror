defmodule Akedia.Repo.Migrations.CreateMentions do
  use Ecto.Migration

  def change do
    create table(:mentions) do
      add :source, :string
      add :target, :string
      add :content_plain, :text
      add :content_html, :text
      add :title, :string
      add :published_at, :naive_datetime
      add :url, :string
      add :in_reply_to, :string
      add :like_of, :string
      add :repost_of, :string
      add :bookmark_of, :string
      add :wm_property, :string
      add :author_id, references(:mention_authors, on_delete: :nothing)
      add :entity_id, references(:entities, on_delete: :delete_all)

      timestamps()
    end

    create index(:mentions, [:entity_id])
    create index(:mentions, [:author_id])
  end
end
