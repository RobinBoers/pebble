defmodule PebbleWeb.SchemasLive do
  @moduledoc false
  use PebbleWeb, :live_view

  alias Pebble.Repo
  alias Pebble.Schema

  import Pebble, only: [fetch_schemas: 0, get_schema: 1]

  @decorate_all wrap_noreply()

  @listings [
    {"Table", :table},
    {"Inline", :inline}
  ]

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    case get_schema(id) do
      %Schema{} = schema ->
        socket
        |> assign(:schema, schema)
        |> assign(:schemas, fetch_schemas())
        |> assign(:listings, @listings)
        |> assign(:changeset, Schema.changeset(schema))

      nil ->
        push_patch(socket, to: ~p"/#{socket.assigns.site}/schemas")
    end
  end

  @impl true
  def handle_params(_params, _url, socket) do
    socket
    |> assign(:schemas, fetch_schemas())
    |> assign(:changeset, Schema.changeset())
  end

  @impl true
  def handle_event("create-schema", %{"schema" => params}, socket) do
    changeset = Schema.changeset(%Schema{}, params)

    case Repo.insert(changeset) do
      {:ok, schema} ->
        push_patch(socket, to: ~p"/#{socket.assigns.site}/schemas/#{schema}")

      {:error, changeset} ->
        assign(socket, :changeset, changeset)
    end
  end

  @impl true
  def handle_event("save-schema", %{"schema" => params}, socket) do
    changeset = Schema.changeset(socket.assigns.schema, params)

    case Repo.update(changeset) do
      {:ok, schema} ->
        push_patch(socket, to: ~p"/#{socket.assigns.site}/schemas/#{schema}")

      {:error, changeset} ->
        assign(socket, :changeset, changeset)
    end
  end

  @impl true
  def handle_event("delete-schema", _params, socket) do
    case Repo.delete(socket.assigns.schema) do
      {:ok, schema} ->
        push_patch(socket, to: ~p"/#{socket.assigns.site}/schemas")

      {:error, changeset} ->
        assign(socket, :changeset, changeset)
    end
  end

  @impl true
  def render(assigns) when assigns.live_action in [:schemas, :new] do
    ~H"""
    <header class="bar">
      <h2>Schemas</h2>
      <.link patch={~p"/#{@site}/schemas/new"} class="button">New schema</.link>
    </header>

    <.modal :if={@live_action == :new} on_close={JS.navigate(~p"/#{@site}/schemas")}>
      <.form :let={f} for={@changeset} phx-submit="create-schema">
        <.input field={f[:label]} label="Label" required />

        <div class="group">
          <.link patch={~p"/#{@site}/schemas"} class="button">Cancel</.link>
          <button>Create</button>
        </div>
      </.form>
    </.modal>

    <p :if={@schemas == []} class="placeholder-text">No schemas yet.</p>

    <ul>
      <li :for={schema <- @schemas}>
        <.link patch={~p"/#{@site}/schemas/#{schema}"}>{schema.label}</.link>
      </li>
    </ul>
    """
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.form
      :let={f} for={@changeset}
      phx-submit="save-schema"
      phx-change="save-schema"
      phx-debounce="blur"
    >
      <header class="bar">
        <.input field={f[:label]} title placeholder="Label" />
        <button>Save</button>
      </header>
      <.input field={f[:definition]} type="textarea" phx-debounce="blur" />
      <div class="options">
        <button
          phx-click="delete-schema"
          data-confirm="Are you sure? This will permanently and irreversibly delete this schema and all fragments using it. This action cannot be undone."
        >
          Delete
        </button>

        <.input field={f[:listing]} type="select" label="Rendering:" options={@listings} />
      </div>
    </.form>
    """
  end
end
