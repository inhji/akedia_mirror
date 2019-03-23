defmodule Akedia.Repo.Migrations.CreateBookmarks do
  use Ecto.Migration

  def change do
    create table(:bookmarks) do
      add :title, :string
      add :url, :string
      add :content, :text
      add :slug, :string
      add :entity_id, references(:entities, on_delete: :nothing)

      timestamps()
    end

    create index(:bookmarks, [:entity_id])
    create unique_index(:bookmarks, [:slug])
  end
end
