defmodule Akedia.Repo.Migrations.AddRsaKeyToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :priv_key, :text
      add :pub_key, :text
    end
  end
end
