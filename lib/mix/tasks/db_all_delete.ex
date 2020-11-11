defmodule Mix.Tasks.DbAllDelete do
  use Mix.Task

  def run(_) do
    Mix.Task.run("app.start", [])

    NervesJpChart.Repo.delete_all(NervesJpChart.Measurements.Value)
    NervesJpChart.Repo.delete_all(NervesJpChart.Accounts.User)
  end
end
