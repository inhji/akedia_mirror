defmodule Akedia.Repo.Migrations.AddRelValueToProfiles do
  use Ecto.Migration

  def change do
    alter table(:profiles) do
      add :rel_value, :string
    end
  end
end
