defmodule Akedia.Workers.Weather do
  use GenServer

  @fetch_interval 600_000 # 10 Minutes

  # Client

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def get_weather() do
    GenServer.call(__MODULE__, :weather)
  end

  def update() do
    GenServer.cast(__MODULE__, :update)
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
    new_state = do_weather_fetch(state)
    {:noreply, new_state}
  end

  def handle_call(:weather, _from, state) do
    {:reply, state[:weather], state}
  end

  def handle_cast(:update, state) do
    new_state = do_weather_fetch(state)

    {:noreply, new_state}
  end

  defp fetch_weather(state) do
    "https://api.darksky.net/forecast/#{state[:key]}/#{state[:location]}"
    |> HTTPoison.get!()
    |> Map.get(:body)
    |> Jason.decode!()
  end

  defp to_celsius(temp) do
    (temp - 32) * (5 / 9)
  end

  defp do_weather_fetch(state) do
    weather =
      state
      |> fetch_weather()
      |> get_weather()

    IO.inspect(weather)

    schedule_weather_fetch()
    Map.put(state, :weather, weather)
  end

  def get_weather(data) do
    temperature =
      data
      |> Map.get("currently")
      |> Map.get("temperature")
      |> to_celsius()
      |> Float.round(1)

    icon =
      data
      |> Map.get("currently")
      |> Map.get("icon")

    text_now =
      data
      |> Map.get("currently")
      |> Map.get("summary")

    text_hourly =
      data
      |> Map.get("hourly")
      |> Map.get("summary")

    %{
      icon: icon,
      temperature: temperature,
      text_now: text_now,
      text_hourly: text_hourly
    }
  end

  defp schedule_weather_fetch do
    Process.send_after(self(), :weather_fetch, @fetch_interval)
  end
end
