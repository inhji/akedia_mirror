defmodule AkediaWeb.QueueController do
  use AkediaWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def drafts(conn, _params) do
    drafts = Akedia.Content.list_drafted_posts()

    render(conn, "drafts.html", posts: drafts)
  end

  def jobs(conn, _params) do
    failed_jobs = Akedia.Jobs.list_failed_jobs()
    completed_jobs = Akedia.Jobs.list_completed_jobs()

    render(conn, "jobs.html", failed_jobs: failed_jobs, completed_jobs: completed_jobs)
  end
end
