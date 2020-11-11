defmodule NervesJpChartWeb.ValueControllerTest do
  use NervesJpChartWeb.ConnCase

  alias NervesJpChart.Measurements

  @create_attrs %{
    value: 120.5,
    kind: 0,
    time: 0,
    name: "nervesjp"
  }
  @invalid_attrs %{value: nil, name: "nervesjp"}

  def fixture(:value) do
    user = NervesJpChart.Accounts.get_or_insert_user("nervesjp")
    {:ok, value} = Measurements.create_value(user, @create_attrs)
    value
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create value" do
    test "renders value when data is valid", %{conn: conn} do
      conn = post(conn, Routes.value_path(conn, :create), value: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.value_path(conn, :show, id))

      assert %{
               "id" => id,
               "value" => 120.5
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.value_path(conn, :create), value: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
