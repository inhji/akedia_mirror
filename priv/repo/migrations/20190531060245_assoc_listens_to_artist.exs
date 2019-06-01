defmodule Akedia.Repo.Migrations.AssocListensToArtist do
  use Ecto.Migration

  def change do
    alter table(:listens) do
      remove :artist
      remove :album

      add :album_id, references(:albums)
      add :artist_id, references(:artists)
    end
  end
end
