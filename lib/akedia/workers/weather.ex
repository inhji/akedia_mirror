defmodule Akedia.Workers.Weather do
  use GenServer

  @fetch_interval 30_000

  # Client

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def get_temperature() do
  	GenServer.call(__MODULE__, :temp)
  end

  # Server Callbacks

  def init(state) do
    settings = Application.get_env(:akedia, Akedia.Settings)

    state =
      state
      |> Map.put(:key, settings[:weather_apikey])
      |> Map.put(:location, settings[:weather_location])

    schedule_weather_fetch()
    {:ok, state}
  end

  def handle_info(:weather_fetch, state) do
    weather = fetch_weather(state)

    temperature =
      weather
      |> Map.get("temperature")
      |> to_celsius()
      |> Float.round(1)

    IO.inspect("Current temperature: #{temperature}")

    schedule_weather_fetch()
    {:noreply, Map.put(state, :temp, temperature)}
  end


  def handle_call(:temp, _from, state) do
  	{:reply, state[:temp], state}
  end

  defp fetch_weather(state) do
    "https://api.darksky.net/forecast/#{state[:key]}/#{state[:location]}"
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> Jason.decode!()
    |> Map.get("currently")
  end

  defp to_celsius(temp) do
    (temp - 32) * (5 / 9)
  end

  defp schedule_weather_fetch do
    Process.send_after(self(), :weather_fetch, @fetch_interval)
  end
end
