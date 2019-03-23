defmodule Akedia.Repo.Migrations.CreateStories do
  use Ecto.Migration

  def change do
    create table(:stories) do
      add :title, :string
      add :slug, :string
      add :content, :text
      add :entity_id, references(:entities, on_delete: :nothing)

      timestamps()
    end

    create index(:stories, [:entity_id])
    create unique_index(:stories, [:slug])
  end
end
