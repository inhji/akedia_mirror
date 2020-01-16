defmodule Akedia.Repo.Migrations.CreateIndieContexts do
  use Ecto.Migration

  def change do
    create table(:indie_contexts) do
      add :content, :text
      add :content_html, :text
      add :url, :string
      add :published_at, :naive_datetime
      add :author_id, references(:indie_authors, on_delete: :nothing)
      add :entity_id, references(:entities, on_delete: :delete_all)

      timestamps()
    end

    create index(:indie_contexts, [:author_id])
    create index(:indie_contexts, [:entity_id])
  end
end
