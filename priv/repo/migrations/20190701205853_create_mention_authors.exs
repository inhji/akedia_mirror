defmodule Akedia.Repo.Migrations.CreateMentionAuthors do
  use Ecto.Migration

  def change do
    create table(:mention_authors) do
      add :name, :string
      add :photo, :string
      add :type, :string
      add :url, :string

      timestamps()
    end
  end
end
