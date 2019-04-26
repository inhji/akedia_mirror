defmodule Akedia.Repo.Migrations.CreateLikes do
  use Ecto.Migration

  def change do
    create table(:likes) do
      add :url, :string

      timestamps()
    end

  end
end
