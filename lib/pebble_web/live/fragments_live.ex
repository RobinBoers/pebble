defmodule PebbleWeb.FragmentsLive do
  @moduledoc false
  use PebbleWeb, :live_view

  alias Pebble.Repo
  alias Pebble.Schema
  alias Pebble.Fragment
  alias Pebble.Changeset

  import Pebble, only: [
        get_schema: 1,
        fetch_schemas: 0,
        get_fragment: 1,
        fetch_fragments: 2
      ]
    
  import Structo

  @decorate_all wrap_noreply()

  @listings [
    {"Table", :table},
    {"Inline", :inline}
  ]

  @impl true
  def handle_params(%{"schema" => schema_id, "id" => id}, _url, socket) do
    case get_fragment(id) do
      %Fragment{} = fragment ->
        socket
        |> assign(:fragment, fragment)
        |> assign(:schema, fragment.schema)
        |> assign(:changeset, Changeset.new(fragment, socket.assigns.site))

      nil ->
        push_patch(socket, to: ~p"/#{socket.assigns.site}/fragments/#{schema_id}")
    end
  end

  @impl true
  def handle_params(%{"schema" => id}, _url, socket) do
    case get_schema(id) do
      %Schema{} = schema ->
        socket
        |> assign(:schema, schema)
        |> assign(:fragments, fetch_fragments(id, socket.assigns.site))
        |> assign(:changeset, Changeset.new(schema, socket.assigns.site))

      nil ->
        push_patch(socket, to: ~p"/#{socket.assigns.site}/fragments")
    end
  end

  # TODO(robin): we should split the schema editor up over this LiveView
  # and the settings panel.

  @impl true
  def handle_params(_params, _url, socket) do
    assign(socket, :schemas, fetch_schemas())
  end

  @impl true
  def handle_event("create-fragment", %{"fragment" => params}, socket) do
    changeset = Fragment.changeset_for(socket.assigns.changeset, params)

    case Repo.insert(changeset) do
      {:ok, fragment} ->
        ~m{site, schema} = socket.assigns
        push_patch(socket, to: ~p"/#{site}/fragments/#{schema}/#{fragment}", replace: true)

      {:error, changeset} ->
        assign(socket, :changeset, changeset)
    end
  end

  @impl true
  def handle_event("save-fragment", %{"fragment" => params}, socket) do
    changeset = Fragment.changeset_for(socket.assigns.changeset, params)

    case Repo.update(changeset) do
      {:ok, fragment} ->
        ~m{site, schema} = socket.assigns
        push_patch(socket, to: ~p"/#{site}/fragments/#{schema}/#{fragment}", replace: true)

      {:error, changeset} ->
        assign(socket, :changeset, changeset)
    end
  end

  @impl true
  def render(assigns) when assigns.live_action == :schemas do
    ~H"""
    <header class="bar">
      <h2>Fragments</h2>
    </header>

    <p :if={@schemas == []} class="placeholder-text">No schemas yet.</p>

    <ul>
      <li :for={schema <- @schemas}>
        <.link patch={~p"/#{@site}/fragments/#{schema}"}>{schema.label}s</.link>
        <span class="actions">
          <.link href={~p"/#{@site}/schemas/#{schema}"}>
            Edit
          </.link>
        </span>
      </li>
    </ul>
    """
  end

  @impl true
  def render(assigns) when assigns.live_action in [:listing, :new] do
    ~H"""
    <header class="bar">
      <h2>{@schema.label}s</h2>
      <.link patch={~p"/#{@site}/fragments/#{@schema}/new"} class="button">
        new {@schema.label}
      </.link>
    </header>

    <.modal :if={@live_action == :new} on_close={JS.navigate(~p"/#{@site}/fragments/#{@schema}")}>
      <.form :let={f} for={@changeset} phx-submit="create-fragment">
        <.input
          :for={{name, d} <- @schema.fields}
          :if={d[:required]}
          field={f[name]}
          label={d[:label] || labelify(name)}
          options={d[:options]}
          class="schema-input"
        />

        <div class="group">
          <.link patch={~p"/#{@site}/fragments/#{@schema}"} class="button">Cancel</.link>
          <button>Create</button>
        </div>
      </.form>
    </.modal>

    <p :if={@fragments == []} class="placeholder-text">No fragments yet.</p>
    """
  end

  @impl true
  def render(assigns) when assigns.live_action == :edit do
    ~H"""
    <header class="bar">
      <h2>Edit fragment</h2>
    </header>

    <.form
      :let={f} for={@changeset}
      phx-change="save-fragment"
      phx-submit="save-fragment"
    >
      <.input
        :for={{name, d} <- @schema.fields}
        field={f[name]}
        label={d[:label] || labelify(name)}
        options={d[:options]}
        class="schema-input"
      />
    </.form>
    """
  end

  defp labelify(name) do
    name |> to_string() |> String.capitalize()
  end
end
