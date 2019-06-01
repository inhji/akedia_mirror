defmodule Akedia.Repo.Migrations.CreateArtists do
  use Ecto.Migration

  def change do
    create table(:artists) do
      add :name, :string
      add :mbid, :string

      timestamps()
    end

  end
end
