defmodule Akedia.Repo.Migrations.CreateEntityImages do
  use Ecto.Migration

  def change do
    create table(:entity_images) do
      add :image_id, references(:images, on_delete: :nothing)
      add :entity_id, references(:entities, on_delete: :nothing)

      timestamps()
    end

    create index(:entity_images, [:image_id])
    create index(:entity_images, [:entity_id])
    create unique_index(:entity_images, [:entity_id, :image_id])
  end
end
