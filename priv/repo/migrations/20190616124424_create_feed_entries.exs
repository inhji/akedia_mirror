defmodule Akedia.Repo.Migrations.CreateFeedEntries do
  use Ecto.Migration

  def change do
    create table(:feed_entries) do
      add :title, :string
      add :summary, :text
      add :author, :string
      add :url, :string
      add :feed_id, references(:feeds, on_delete: :nothing)

      timestamps()
    end

    create index(:feed_entries, [:feed_id])
    create unique_index(:feed_entries, [:url])
  end
end
