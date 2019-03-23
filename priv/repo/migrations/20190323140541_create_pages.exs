defmodule Akedia.Repo.Migrations.CreatePages do
  use Ecto.Migration

  def change do
    create table(:pages) do
      add :title, :string
      add :slug, :string
      add :content, :text
      add :entity_id, references(:entities, on_delete: :nothing)

      timestamps()
    end

    create index(:pages, [:entity_id])
    create unique_index(:pages, [:slug])
  end
end
