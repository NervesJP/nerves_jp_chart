defmodule NervesJpChart.Repo.Migrations.CreateValues do
  use Ecto.Migration

  def change do
    create table(:values) do
      add :value, :float, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:values, [:user_id])
  end
end
