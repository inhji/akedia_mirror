defmodule Akedia.Repo.Migrations.AddSlugToTopic do
  use Ecto.Migration

  def change do
    alter table(:topics) do
      add :slug, :string
    end
  end
end
