defmodule Akedia.Repo.Migrations.AddIconAndPlacementFieldsToProfiles do
  use Ecto.Migration

  def change do
    alter table(:profiles) do
      add :icon, :string
      add :public, :boolean
    end
  end
end
