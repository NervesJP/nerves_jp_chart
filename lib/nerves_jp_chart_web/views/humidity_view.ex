defmodule NervesJpChartWeb.HumidityView do
  use NervesJpChartWeb, :view
  alias NervesJpChartWeb.HumidityView

  def render("show.json", %{value: value}) do
    %{data: render_one(value, HumidityView, "value.json")}
  end

  def render("value.json", %{humidity: value}) do
    %{id: value.id, value: value.value, time: value.time}
  end
end
