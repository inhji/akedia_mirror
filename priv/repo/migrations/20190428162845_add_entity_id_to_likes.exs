defmodule Akedia.Repo.Migrations.AddEntityIdToLikes do
  use Ecto.Migration

  def change do
    alter table(:likes) do
      add :entity_id, references(:entities, on_delete: :nothing)
    end

    create index(:likes, [:entity_id])
  end
end
