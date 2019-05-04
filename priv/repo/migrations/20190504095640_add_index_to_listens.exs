defmodule Akedia.Repo.Migrations.AddIndexToListens do
  use Ecto.Migration

  def change do
    create index(:listens, [:artist])
    create index(:listens, [:track])
  end
end
