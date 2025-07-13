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

    get "/identity", IdentityController, :identity
    put "/identity", IdentityController, :edit
    get "/schemas/identity", IdentityController, :schema
    put "/schemas/identity", IdentityController, :edit_schema

    get "/s/:schema", FragmentsController, :fragments
    post "/s/:schema", FragmentsController, :new
    get "/s/:schema/:id", FragmentsController, :fragment
    put "/s/:schema/:id", FragmentsController, :edit
    delete "/s/:schema/:id", FragmentsController, :delete

    get "/endpoints", ConsoleController, :endpoints
    get "/shell", ConsoleController, :shell
    get "/logs", ConsoleController, :logs

    get "/preferences", SettingsController, :settings

    get "/menu", MenuController, :menu
    put "/menu", MenuController, :update

    get "/menu/items/:id", MenuController, :item
    post "/menu/items", MenuController, :new_item
    put "/menu/items/:id", MenuController, :edit_item
    delete "/menu/items/:id", MenuController, :delete_item

    get "/menu/categories/:id", MenuController, :category
    post "/menu/categories", MenuController, :new_category
    put "/menu/categories/:id", MenuController, :edit_category
    delete "/menu/categories/:id", MenuController, :delete_category
  end
end
