defmodule NervesJpChart.Measurements.Value do
  use Ecto.Schema
  import Ecto.Changeset

  schema "values" do
    field :value, :float
    belongs_to :user, NervesJpChart.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(value, attrs) do
    value
    |> cast(attrs, [:value])
    |> validate_required([:value])
  end
end
