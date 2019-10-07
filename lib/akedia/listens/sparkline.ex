defmodule Akedia.Listens.Sparkline do
  def create(listens_per_month, oldest_listen, newest_listen) do
    [_, date_first] = List.first(listens_per_month)
    [_, date_last] = List.last(listens_per_month)

    beginning_interval = get_duration(oldest_listen.listened_at, date_first)
    end_interval = get_duration(date_last, newest_listen.listened_at)

    filled_listens =
      listens_per_month
      |> fill_gaps()

    fill_list(beginning_interval) ++
      filled_listens ++
      fill_list(end_interval)
  end

  defp fill_list(0), do: []
  defp fill_list(count), do: Enum.reduce(1..count, [], fn _, acc -> acc ++ [0] end)

  defp get_duration(start_date, end_date) do
    if Timex.after?(start_date, end_date) do
      0
    else
      Timex.Interval.new(from: start_date, until: end_date, step: [months: 1])
      |> Timex.Interval.duration(:months)
    end
  end

  defp fill_gaps(listens) do
    new_list =
      for {[count, listen], index} <- Enum.with_index(listens) do
        case Enum.at(listens, index + 1) do
          nil ->
            count

          [_, next_listen] ->
            duration =
              Timex.Interval.new(from: listen, until: next_listen)
              |> Timex.Interval.duration(:months)
              |> fill_list()

            [count] ++ duration
        end
      end

    List.flatten(new_list)
  end
end
