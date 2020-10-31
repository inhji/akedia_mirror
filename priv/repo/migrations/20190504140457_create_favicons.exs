defmodule Akedia.Repo.Migrations.CreateFavicons do
  use Ecto.Migration

  def change do
    create table(:favicons) do
      add :name, :string
      add :hostname, :string

      timestamps()
    end

    alter table(:bookmarks) do
      remove :favicon
      add :favicon_id, references(:favicons, on_delete: :nothing)
    end
  end
end
