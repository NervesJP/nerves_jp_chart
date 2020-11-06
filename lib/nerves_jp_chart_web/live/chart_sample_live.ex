defmodule NervesJpChartWeb.ChartSampleLive do
  use NervesJpChartWeb, :live_view

  def mount(_params, _session, socket) do
    :timer.send_interval(1_000, self(), :next_values)
    socket = assign(socket, values: Jason.encode!([]), users: Jason.encode!([]), cnt: 0)
    {:ok, socket}
  end

  def handle_info(:next_values, socket) do
    new_cnt = socket.assigns.cnt + 1
    new_cnt = min(100, new_cnt)
    values = 1..new_cnt |> Enum.map(fn _ -> :random.uniform() end)
    users = 1..new_cnt |> Enum.map(&"user#{&1}")

    {:noreply,
     assign(socket,
       values: Jason.encode!(values),
       users: Jason.encode!(users),
       cnt: new_cnt
     )}
  end

  def render(assigns) do
    ~L"""
    <div id="data" data-values="<%= @values %>" data-users="<%= @users %>">
    <div phx-update="ignore">
      <canvas id="myChart" phx-hook="chart" width="200" height="200"></canvas>
    </div>

    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
    <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/chart.js@2.9.4"></script>
    <script type="text/javascript" src="<%= System.get_env("NERVES_JP_CHART_CDN") %>/chartjs-plugin-streaming.js"></script>
    <pre><%= @values %></pre>
    """
  end
end
