defmodule AkediaWeb.Helpers.Time do
  use Phoenix.HTML

  def date_iso(date) do
    Timex.format!(date, "{ISO:Extended:Z}")
  end

  def date_pretty(date) do
    Timex.format!(date, "{D}. {Mfull} {YYYY}")
  end

  def date_fuzzy(date) do
    Timex.from_now(date)
  end

  def time_tag(date) do
    content_tag(:time, date_fuzzy(date),
      datetime: date_iso(date),
      title: date_pretty(date)
    )
  end
end
