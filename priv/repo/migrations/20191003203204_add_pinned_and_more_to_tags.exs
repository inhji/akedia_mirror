defmodule Akedia.Repo.Migrations.AddPinnedAndMoreToTags do
  use Ecto.Migration

  def change do
    alter table(:topics) do
      add :is_pinned, :boolean
      add :description, :string
      add :icon, :string
    end
  end
end
