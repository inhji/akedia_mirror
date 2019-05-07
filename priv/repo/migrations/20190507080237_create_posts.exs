defmodule Akedia.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :content, :text
      add :slug, :string

      add :reply_to, :string

      add :entity_id, references(:entities, on_delete: :nothing)

      timestamps()
    end

    create index(:posts, [:entity_id])
    create unique_index(:posts, [:slug])
  end
end
