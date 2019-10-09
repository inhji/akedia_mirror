defmodule Akedia.Workers.ListenbrainzNow do
  use GenServer
  require Logger

  # 10 Minutes
  @fetch_interval 60_000

  def start_link(opts) do
    args = %{
      user: opts.username,
      now: nil
    }

    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def get_now() do
    GenServer.call(__MODULE__, :now)
  end

  def init(state) do
    schedule_listen_fetch(1_000)
    {:ok, state}
  end

  def handle_info(:fetch, state) do
    listening_now = do_fetch(state)
    new_state = %{state | now: listening_now}

    schedule_listen_fetch(@fetch_interval)
    {:noreply, new_state}
  end

  def handle_call(:now, _from, state) do
    {:reply, state[:now], state}
  end

  defp schedule_listen_fetch(interval) do
    Process.send_after(self(), :fetch, interval)
  end

  def do_fetch(%{:user => user}) do
    case HTTPoison.get!("https://api.listenbrainz.org/1/user/#{user}/playing-now") do
      %HTTPoison.Response{body: body} ->
        body
        |> Jason.decode!(keys: :atoms)
        |> Map.get(:payload)
        |> Map.get(:listens)
        |> List.first()

      _ ->
        nil
    end
  end
end
