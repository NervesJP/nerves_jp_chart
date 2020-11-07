defmodule NervesJpChartWeb.ValueView do
  use NervesJpChartWeb, :view
  alias NervesJpChartWeb.ValueView

  def render("index.json", %{values: values}) do
    %{data: render_many(values, ValueView, "value.json")}
  end

  def render("show.json", %{value: value}) do
    %{data: render_one(value, ValueView, "value.json")}
  end

  def render("value.json", %{value: value}) do
    %{id: value.id, value: value.value}
  end
end
