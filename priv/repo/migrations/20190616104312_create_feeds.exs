defmodule Akedia.Repo.Migrations.CreateFeeds do
  use Ecto.Migration

  def change do
    create table(:feeds) do
      add :url, :string
      add :title, :string
      add :description, :string

      add :channel_id, references(:channels, on_delete: :nothing)

      timestamps()
    end

    create index(:feeds, [:channel_id])
  end
end
