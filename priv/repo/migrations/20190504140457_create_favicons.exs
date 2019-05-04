defmodule Akedia.Repo.Migrations.CreateFavicons do
  use Ecto.Migration

  def change do
    create table(:favicons) do
      add :name, :string
      add :tld, :string

      timestamps()
    end

  end
end
