defmodule Akedia.Repo.Migrations.CreateSyndications do
  use Ecto.Migration

  def change do
    create table(:syndications) do
      add :type, :string
      add :url, :string
      add :entity_id, references(:entities, on_delete: :nothing)

      timestamps()
    end

    create index(:syndications, [:entity_id])
  end
end
