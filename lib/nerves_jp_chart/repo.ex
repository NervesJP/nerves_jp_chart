defmodule NervesJpChart.Repo do
  use Ecto.Repo,
    otp_app: :nerves_jp_chart,
    adapter: Ecto.Adapters.Postgres
end
