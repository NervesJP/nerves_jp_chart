defmodule NervesJpChart.Repo.Migrations.AddKindTimeToValues do
  use Ecto.Migration

  def change do
    alter table(:values) do
      add :kind, :integer, null: false, default: 0
      add :time, :integer, null: false, default: 0
    end

    create index(:values, [:kind])
  end
end
