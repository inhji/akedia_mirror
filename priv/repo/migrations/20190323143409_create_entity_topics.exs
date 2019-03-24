defmodule Akedia.Repo.Migrations.CreateEntityTopics do
  use Ecto.Migration

  def change do
    create table(:entity_topics) do
      add :entity_id, references(:entities, on_delete: :delete_all)
      add :topic_id, references(:topics, on_delete: :nothing)

      timestamps()
    end

    create index(:entity_topics, [:entity_id])
    create index(:entity_topics, [:topic_id])
    create unique_index(:entity_topics, [:entity_id, :topic_id])
  end
end
