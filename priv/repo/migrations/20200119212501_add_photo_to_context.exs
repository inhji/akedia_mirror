defmodule Akedia.Repo.Migrations.AddPhotoToContext do
  use Ecto.Migration

  def change do
    alter table(:indie_contexts) do
      add :photo, :string
    end
  end
end
