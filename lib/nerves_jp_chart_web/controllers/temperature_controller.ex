defmodule NervesJpChartWeb.TemperatureController do
  use NervesJpChartWeb, :controller

  alias NervesJpChart.Measurements
  alias NervesJpChart.Measurements.Value

  action_fallback NervesJpChartWeb.FallbackController

  def create(conn, %{"value" => value_params}) do
    %{"name" => name} = value_params
    user = NervesJpChart.Accounts.get_or_insert_user(name)
    value_params = Map.put(value_params, "kind", 0)

    with {:ok, %Value{} = value} <- Measurements.create_value(user, value_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.temperature_path(conn, :show, value))
      |> render("show.json", value: value)
    end
  end

  def show(conn, %{"id" => id}) do
    value = Measurements.get_value!(id)
    render(conn, "show.json", value: value)
  end
end
