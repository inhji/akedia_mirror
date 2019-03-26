defmodule Akedia.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :name, :string
      add :text, :string
      add :path, :string

      timestamps()
    end
  end
end
