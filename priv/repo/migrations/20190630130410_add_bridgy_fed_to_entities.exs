defmodule Akedia.Repo.Migrations.AddBridgyFedToEntities do
  use Ecto.Migration

  def change do
    alter table(:entities) do
      add :bridgy_fed, :boolean, default: false, null: false
    end
  end
end
