defmodule NervesJpChartWeb.TemperatureView do
  use NervesJpChartWeb, :view
  alias NervesJpChartWeb.TemperatureView

  def render("show.json", %{value: value}) do
    %{data: render_one(value, TemperatureView, "value.json")}
  end

  def render("value.json", %{temperature: value}) do
    %{id: value.id, value: value.value, time: value.time}
  end
end
