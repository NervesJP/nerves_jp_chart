defmodule NervesJpChart.Accounts do
  import Ecto.Query, warn: false
  alias NervesJpChart.Repo

  alias NervesJpChart.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_or_insert_user(name) do
    Repo.get_by(User, name: name) ||
      maybe_insert_user(name)
  end

  defp maybe_insert_user(name) do
    %User{}
    |> NervesJpChart.Accounts.User.changeset(%{name: name})
    |> Repo.insert()
    |> case do
      {:ok, user} -> user
      {:error, _} -> Repo.get_by!(User, name: name)
    end
  end
end
