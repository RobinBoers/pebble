defmodule PebbleWeb.Router do
  use PebbleWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PebbleWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", PebbleWeb do
    pipe_through :browser

    live "/", DashboardLive, :dashboard
    live "/fragments", FragmentsLive, :fragments
    live "/templates", TemplatesLive, :templates
    live "/endpoints", EndpointsLive, :endpoints
    live "/shell", ShellLive, :shell
    live "/layouts", LayoutsLive, :layouts
    live "/media", MediaLive, :media
    live "/contacts", ContactsLive, :contacts
    live "/menu", MenuLive, :menu
    live "/logs", LogsLive, :logs
    live "/stats", StatisticsLive, :statistics
    live "/settings", SettingsLive, :settings
    live "/schemas", SettingsLive, :schemas
  end
end
