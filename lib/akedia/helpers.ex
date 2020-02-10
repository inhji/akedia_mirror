defmodule Akedia.Helpers do
  @default_context ["https://www.w3.org/ns/activitystreams"]
  @context_name "@context"
  @format_string "{WDshort}, {0D} {Mshort} {YYYY} {h24}:{m}:{s} GMT"

  def with_context(%{} = object), do: Map.put(object, @context_name, @default_context)

  def with_context(%{} = object, extra_context) do
    new_context =
      if Map.has_key?(object, @context_name) do
        Map.get(object, @context_name) ++ extra_context
      else
        @default_context ++ extra_context
      end

    Map.put(object, @context_name, new_context)
  end

  def httpdate, do: DateTime.utc_now() |> Timex.format(@format_string)
  def httpdate(date), do: date |> Timex.format(@format_string)
end
