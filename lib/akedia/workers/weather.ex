defmodule Akedia.Workers.Weather do
  use GenServer
  require Logger

  # 10 Minutes
  @fetch_interval 600_000

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

    schedule_weather_fetch(10_000)
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
    url = "https://api.darksky.net/forecast/#{state[:key]}/#{state[:location]}"

    Logger.info("Fetching weather...")
    Logger.info("URL: #{url}")

    url
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

    Logger.info("Weather fetched!")
    Logger.info("#{inspect(weather)}")

    schedule_weather_fetch()
    Map.put(state, :weather, weather)
  end

  def get_weather(data) do
    temperature =
      data
      |> currently()
      |> Map.get("temperature")
      |> to_celsius()
      |> Float.round(1)

    humidity =
      data
      |> currently()
      |> Map.get("humidity")

    now =
      data
      |> currently()
      |> Map.get("summary")

    summary =
      data
      |> today()
      |> Map.get("summary")

    icon =
      data
      |> currently()
      |> Map.get("icon")

    max =
      data
      |> today()
      |> Map.get("temperatureHigh")
      |> to_celsius()
      |> Float.round(1)

    min =
      data
      |> today()
      |> Map.get("temperatureLow")
      |> to_celsius()
      |> Float.round(1)

    %{
      temperature: temperature,
      humidity: humidity,
      now: now,
      summary: summary,
      icon: icon,
      min: min,
      max: max
    }
  end

  def today(data) do
    data
    |> Map.get("daily")
    |> Map.get("data")
    |> List.first()
  end

  def currently(data) do
    data
    |> Map.get("currently")
  end

  defp schedule_weather_fetch do
    Process.send_after(self(), :weather_fetch, @fetch_interval)
  end

  defp schedule_weather_fetch(wait_time) do
    Process.send_after(self(), :weather_fetch, wait_time)
  end
end
