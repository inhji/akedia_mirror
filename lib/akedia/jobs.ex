defmodule Akedia.Jobs do
  import Ecto.Query, warn: false
  alias Akedia.Repo

  def list_jobs() do
    Repo.all(Oban.Job)
  end

  def list_failed_jobs() do
    Oban.Job
    |> where(state: "retryable")
    |> or_where(state: "discarded")
    |> Repo.all()
  end

  def list_completed_jobs() do
    Oban.Job
    |> where(state: "completed")
    |> Repo.all()
  end
end
