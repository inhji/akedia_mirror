defmodule Akedia.Repo.Migrations.AddBioAndTaglineToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :bio, :text
      add :tagline, :text
    end
  end
end
