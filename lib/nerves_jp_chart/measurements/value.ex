defmodule NervesJpChart.Measurements.Value do
  use Ecto.Schema
  import Ecto.Changeset

  schema "values" do
    field :value, :float
    field :kind, :integer
    field :time, :integer
    belongs_to :user, NervesJpChart.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(value, attrs) do
    value
    |> cast(attrs, [:value, :kind, :time])
    |> validate_required([:value, :kind, :time])
  end
end
