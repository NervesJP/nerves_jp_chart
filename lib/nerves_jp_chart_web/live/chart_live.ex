defmodule NervesJpChartWeb.ChartLive do
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
      |> Enum.map(&NervesJpChart.Measurements.last_by_user/1)
      |> Enum.map(& &1.value)

    if Enum.count(users) == Enum.count(values) do
      {:noreply,
       assign(socket,
         values: Jason.encode!(values),
         users: Jason.encode!(users |> Enum.map(& &1.name))
       )}
    else
      {:noreply, socket}
    end
  end

  def render(assigns) do
    ~L"""
    <div id="data" data-values="<%= @values %>" data-users="<%= @users %>">
    <div phx-update="ignore">
      <canvas id="myChart" phx-hook="chart" width="200" height="200"></canvas>
    </div>

    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/chart.js@2.9.4"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/chartjs-plugin-streaming@latest/dist/chartjs-plugin-streaming.min.js"></script>
    <pre>
    <strong>API使用例</strong>
    nameは20文字まで

    # Elixir
    json = Jason.encode!(%{value: %{name: "nervesjp", value: 0.123}})
    HTTPoison.post "https://vain-limegreen-pigeon.gigalixirapp.com/values", json, [{"Content-Type", "application/json"}]

    # curl
    curl -X POST -H "Content-Type: application/json" -d '{"value": {"name": "nervesjp", "value":0.123}}' https://vain-limegreen-pigeon.gigalixirapp.com/values
    </pre>
    <pre><%= @values %></pre>
    """
  end
end
