defmodule Akedia.Repo.Migrations.UpgradeObanJobsToV9 do
  use Ecto.Migration

  defdelegate up, to: Oban.Migrations
  defdelegate down, to: Oban.Migrations
end
