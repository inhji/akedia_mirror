defmodule Akedia.Repo.Migrations.CreateEntities do
  use Ecto.Migration

  def change do
    create table(:entities) do
      add :is_published, :boolean, default: false, null: false
      add :is_pinned, :boolean, default: false, null: false

      timestamps()
    end

  end
end
