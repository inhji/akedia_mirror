defmodule Akedia.Repo.Migrations.AddCoverImageToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :cover, :string
    end
  end
end
