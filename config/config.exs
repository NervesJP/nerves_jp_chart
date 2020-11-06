# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :nerves_jp_chart,
  ecto_repos: [NervesJpChart.Repo]

# Configures the endpoint
config :nerves_jp_chart, NervesJpChartWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "FMy9SiMYba6M8CeYeV5YU9vGS3PhdbTftbXP9b/eY5msfHZtvLlqgtF2/WnSoORd",
  render_errors: [view: NervesJpChartWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: NervesJpChart.PubSub,
  live_view: [signing_salt: "sgpbv5Zx"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
