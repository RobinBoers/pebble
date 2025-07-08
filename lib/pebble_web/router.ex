defmodule PebbleWeb.Router do
  @moduledoc false
  use PebbleWeb, :router

  import PebbleWeb.Navigation

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

    # TODO(robin): when there are no sites, this controller
    # raises. Eventually, we want this to have a rich OOTB
    # experience for new users, allowing them to configure
    # their site and schemas in an user-friendly manner.

    get "/", SetupController, :setup
  end

  scope "/:site", PebbleWeb do
    pipe_through [:browser, :mount_site]

    get "/", DashboardController, :dashboard
    get "/templates", TemplatesController, :templates
    post "/templates", TemplatesController, :new
    get "/templates/:id", TemplatesController, :template
    put "/templates/:id", TemplatesController, :edit
    delete "/templates/:id", TemplatesController, :delete

    get "/layouts", LayoutsController, :layouts
    post "/layouts", LayoutsController, :new
    get "/layouts/:id", LayoutsController, :layout
    put "/layouts/:id", LayoutsController, :edit
    delete "/layouts/:id", LayoutsController, :delete

    get "/contacts", ContactsController, :contacts
    post "/contacts", ContactsController, :new
    get "/contacts/:id", ContactsController, :contact
    put "/contacts/:id", ContactsController, :edit
    delete "/contacts/:id", ContactsController, :delete

    get "/schemas", SchemasController, :schemas
    post "/schemas", SchemasController, :new
    get "/schemas/:id", SchemasController, :schema
    put "/schemas/:id", SchemasController, :edit
    delete "/schemas/:id", SchemasController, :delete

    get "/s/:schema", FragmentsController, :fragments
    post "/s/:schema", FragmentsController, :new
    get "/s/:schema/:id", FragmentsController, :fragment
    put "/s/:schema/:id", FragmentsController, :edit
    delete "/s/:schema/:id", FragmentsController, :delete

    # live "/fragments", FragmentsLive, :schemas
    # live "/s/:schema/new", FragmentsLive, :new
    # live "/s/:schema/:id", FragmentsLive, :edit
    # live "/templates", TemplatesLive, :templates
    # live "/templates/new", TemplatesLive, :new
    # live "/templates/:id", TemplatesLive, :edit
    # live "/templates/:id/add", TemplatesLive, :add
    # live "/endpoints", EndpointsLive, :endpoints
    # live "/console/shell", ShellLive, :shell
    # live "/console/logs", LogsLive, :logs
    # live "/layouts", LayoutsLive, :layouts
    # live "/layouts/new", LayoutsLive, :new
    # live "/layouts/:id", LayoutsLive, :edit
    # live "/media", MediaLive, :media
    # live "/media/upload", MediaLive, :upload
    # live "/contacts", ContactsLive, :contacts
    # live "/contacts/new", ContactsLive, :new
    # live "/contacts/:id", ContactsLive, :edit
    # live "/menu", MenuLive, :menu
    # live "/stats", StatisticsLive, :statistics
    # live "/settings", SettingsLive, :settings
    # live "/schemas", SchemasLive, :schemas
    # live "/schemas/new", SchemasLive, :new
    # live "/schemas/:id", SchemasLive, :edit
  end
end
