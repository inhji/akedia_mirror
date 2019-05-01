defmodule Akedia.Repo.Migrations.CreateListens do
  use Ecto.Migration

  def change do
    create table(:listens) do
      add :track, :string
      add :artist, :string
      add :album, :string
      add :listened_at, :timestamptz

      timestamps(type: :timestamptz)
    end

    create unique_index(:listens, [:listened_at])
  end
end
