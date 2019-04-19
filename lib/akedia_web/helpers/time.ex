defmodule AkediaWeb.Helpers.Time do
  def date_iso(date) do
    Timex.format!(date, "{ISO:Extended:Z}")
  end

  def date_pretty(date) do
    Timex.format!(date, "{D}. {Mfull} {YY}")
  end
end
