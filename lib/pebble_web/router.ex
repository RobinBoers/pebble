defmodule PebbleWeb.Router do
  @moduledoc false
  use PebbleWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PebbleWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  live_session :default, on_mount: PebbleWeb.Navigation do
    scope "/", PebbleWeb do
      pipe_through :browser

      # Only here to enable redirect
      live "/", DashboardLive, :dashboard
    end

    scope "/:site", PebbleWeb do
      pipe_through :browser

      live "/", DashboardLive, :dashboard
      live "/fragments", FragmentsLive, :fragments
      live "/fragments/new", FragmentsLive, :new
      live "/fragments/:id", FragmentsLive, :edit
      live "/templates", TemplatesLive, :templates
      live "/templates/new", TemplatesLive, :new
      live "/templates/:id", TemplatesLive, :edit
      live "/templates/:id/add", TemplatesLive, :add
      live "/endpoints", EndpointsLive, :endpoints
      live "/console/shell", ShellLive, :shell
      live "/console/logs", LogsLive, :logs
      live "/layouts", LayoutsLive, :layouts
      live "/layouts/new", LayoutsLive, :new
      live "/layouts/:id", LayoutsLive, :edit
      live "/media", MediaLive, :media
      live "/media/upload", MediaLive, :upload
      live "/contacts", ContactsLive, :contacts
      live "/contacts/new", ContactsLive, :new
      live "/contacts/:id", ContactsLive, :edit
      live "/menu", MenuLive, :menu
      live "/stats", StatisticsLive, :statistics
      live "/settings", SettingsLive, :settings
      live "/schemas", SchemasLive, :schemas
      live "/schemas/new", SchemasLive, :new
      live "/schemas/:id", SchemasLive, :edit
    end
  end
end
