defmodule NervesJpChart.MeasurementsTest do
  use NervesJpChart.DataCase

  alias NervesJpChart.Measurements

  setup do
    {:ok, user: NervesJpChart.Accounts.get_or_insert_user("nervesjp")}
  end

  describe "values" do
    alias NervesJpChart.Measurements.Value

    @valid_attrs %{value: 120.5, kind: 0, time: 0}
    @update_attrs %{value: 456.7}
    @invalid_attrs %{value: nil}

    def value_fixture(attrs \\ %{}) do
      user = NervesJpChart.Accounts.get_or_insert_user("nervesjp")

      {:ok, value} =
        attrs
        |> Enum.into(@valid_attrs)
        |> (fn attrs -> Measurements.create_value(user, attrs) end).()

      value
    end

    test "list_values/0 returns all values" do
      value = value_fixture()
      assert Measurements.list_values() == [value]
    end

    test "get_value!/1 returns the value with given id" do
      value = value_fixture()
      assert Measurements.get_value!(value.id) |> NervesJpChart.Repo.preload(:user) == value
    end

    test "create_value/1 with valid data creates a value", %{user: user} do
      assert {:ok, %Value{} = value} = Measurements.create_value(user, @valid_attrs)
      assert value.value == 120.5
    end

    test "create_value/1 with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{}} = Measurements.create_value(user, @invalid_attrs)
    end

    test "update_value/2 with valid data updates the value" do
      value = value_fixture()
      assert {:ok, %Value{} = value} = Measurements.update_value(value, @update_attrs)
      assert value.value == 456.7
    end

    test "update_value/2 with invalid data returns error changeset" do
      value = value_fixture()
      assert {:error, %Ecto.Changeset{}} = Measurements.update_value(value, @invalid_attrs)
      assert value == Measurements.get_value!(value.id) |> NervesJpChart.Repo.preload(:user)
    end

    test "delete_value/1 deletes the value" do
      value = value_fixture()
      assert {:ok, %Value{}} = Measurements.delete_value(value)
      assert_raise Ecto.NoResultsError, fn -> Measurements.get_value!(value.id) end
    end

    test "change_value/1 returns a value changeset" do
      value = value_fixture()
      assert %Ecto.Changeset{} = Measurements.change_value(value)
    end
  end
end
