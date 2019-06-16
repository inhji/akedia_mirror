defmodule Akedia.Repo.Migrations.AddUidToChannel do
  use Ecto.Migration

  def change do
    alter table(:channels) do
      add :uid, :string
    end
  end
end
