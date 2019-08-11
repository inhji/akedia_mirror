defmodule Akedia.Repo.Migrations.AssociateImageToEntityDirectly do
  use Ecto.Migration

  def change do
    alter table(:images) do
    	add :entity_id, references(:entities, on_delete: :nothing)
    end
  end
end
