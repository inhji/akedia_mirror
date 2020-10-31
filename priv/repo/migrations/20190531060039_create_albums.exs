defmodule Akedia.Repo.Migrations.CreateAlbums do
  use Ecto.Migration

  def change do
    create table(:albums) do
      add :name, :string
      add :mbid, :string
      add :artist_id, references(:artists, on_delete: :nothing)

      timestamps()
    end
  end
end
