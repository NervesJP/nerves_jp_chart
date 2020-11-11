defmodule NervesJpChartWeb.ChartTemperatureLive do
  use NervesJpChartWeb, :live_view

  def mount(_params, _session, socket) do
    :timer.send_interval(1_000, self(), :next_values)
    socket = assign(socket, values: Jason.encode!([]), users: Jason.encode!([]))
    {:ok, socket}
  end

  def handle_info(:next_values, socket) do
    # TODO N + 1 problem...
    users = NervesJpChart.Accounts.list_users()

    values =
      users
      |> Enum.map(&NervesJpChart.Measurements.last_by_user(&1, 0))

    users =
      Enum.zip(users, values)
      |> Enum.filter(fn {_, value} -> value end)
      |> Enum.map(fn {user, _} -> user end)

    values =
      Enum.reject(values, &(&1 == nil))
      |> Enum.map(& &1.value)
      |> Enum.map(fn value -> if value > 40, do: 40, else: value end)
      |> Enum.map(fn value -> if value < 0, do: 0, else: value end)

    {:noreply,
     assign(socket,
       values: Jason.encode!(values),
       users: Jason.encode!(users |> Enum.map(& &1.name))
     )}
  end

  def render(assigns) do
    ~L"""
    <h1>Temperature</h1>
    <div id="data" data-values="<%= @values %>" data-users="<%= @users %>">
    <div phx-update="ignore">
      <canvas id="myChart" phx-hook="chart" width="200" height="200"></canvas>
    </div>

    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/chart.js@2.9.4"></script>
    <script type="text/javascript" src="<%= System.get_env("NERVES_JP_CHART_CDN") %>/chartjs-plugin-streaming.js"></script>
    <pre>
    <strong>API使用例</strong>
    nameは20文字まで
    timeはUnix time

    # Elixir
    json = Jason.encode!(%{value: %{name: "nervesjp", value: 25.123, time: 1605097502}})
    HTTPoison.post "https://vain-limegreen-pigeon.gigalixirapp.com/temperatures", json, [{"Content-Type", "application/json"}]

    # curl
    curl -X POST -H "Content-Type: application/json" -d '{"value": {"name": "nervesjp", "value": 25.123, "time": 1605097502}}' https://vain-limegreen-pigeon.gigalixirapp.com/temperatures
    </pre>
    <pre><%= @values %></pre>
    """
  end
end
