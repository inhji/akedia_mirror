defmodule Akedia.Repo.Migrations.AddCoverToAlbum do
  use Ecto.Migration

  def change do
    alter table(:albums) do
      add :cover, :string
    end
  end
end
