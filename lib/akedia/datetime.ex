defmodule Akedia.DateTime do
  def to_datetime(datetime_string) when is_binary(datetime_string) do
    Enum.reduce_while(
      [
        &maybe_convert_from_iso_8601/1,
        &maybe_convert_from_rfc_1123/1
      ],
      nil,
      fn strategy, acc ->
        case strategy.(datetime_string) do
          {:error, _} -> {:cont, acc}
          {:ok, datetime} -> {:halt, datetime}
        end
      end
    )
  end

  def to_datetime_utc(nil), do: nil

  def to_datetime_utc(datetime_string) when is_binary(datetime_string) do
    {:ok, datetime_utc} = datetime_string
    |> to_datetime()
    |> DateTime.shift_zone("Etc/UTC")

    datetime_utc
  end

  def to_string(datetime) do
    DateTime.to_iso8601(datetime)
  end

  defp maybe_convert_from_iso_8601(datetime_string) do
    Timex.parse(datetime_string,"{ISO:Extended:Z}")
  end

  defp maybe_convert_from_rfc_1123(datetime_string) do
    Timex.parse(datetime_string, "{RFC1123}")
  end
end
