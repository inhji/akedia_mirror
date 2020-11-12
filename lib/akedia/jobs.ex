defmodule Akedia.Jobs do
  import Ecto.Query, warn: false
  alias Akedia.Repo

  def list_jobs() do
    Repo.all(Oban.Job)
  end

  def list_job_queue() do
    Oban.Job
    |> where(state: "retryable")
    |> or_where(state: "discarded")
    |> Repo.all()
  end
end
