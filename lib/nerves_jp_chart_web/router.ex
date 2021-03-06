defmodule NervesJpChartWeb.Router do
  use NervesJpChartWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {NervesJpChartWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]

    resources "/values", NervesJpChartWeb.ValueController, only: [:create, :show]
    resources "/temperatures", NervesJpChartWeb.TemperatureController, only: [:create, :show]
    resources "/humidities", NervesJpChartWeb.HumidityController, only: [:create, :show]
  end

  scope "/", NervesJpChartWeb do
    pipe_through :browser

    live "/", PageLive, :index
    live "/chart-sample", ChartSampleLive
    live "/chart", ChartLive
    live "/chart-temperature", ChartTemperatureLive
    live "/chart-humidity", ChartHumidityLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", NervesJpChartWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: NervesJpChartWeb.Telemetry
    end
  end
end
