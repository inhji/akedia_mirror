defmodule Akedia.Repo.Migrations.CreateTopics do
  use Ecto.Migration

  def change do
    create table(:topics) do
      add :text, :string

      timestamps()
    end

    create unique_index(:topics, [:text])
  end
end
