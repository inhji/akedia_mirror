defmodule Akedia.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles) do
      add :name, :string
      add :username, :string
      add :url, :string

      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
  end
end
