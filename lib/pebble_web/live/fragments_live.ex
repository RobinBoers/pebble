defmodule PebbleWeb.FragmentsLive do
  @moduledoc false
  use PebbleWeb, :live_view

  alias Pebble.Schema
  alias PebbleWeb.Changeset

  import Pebble, only: [get_schema: 1, fetch_schemas: 0]

  @decorate_all wrap_noreply()

  @impl true
  def handle_params(%{"schema" => id}, _url, socket) do
    case get_schema(id) do
      %Schema{} = schema ->
        socket
        |> assign(:schema, schema)
        |> assign(:schemas, fetch_schemas())
        |> assign(:changeset, Changeset.new(schema))

      nil ->
        push_patch(socket, to: ~p"/#{socket.assigns.site}/fragments")
    end
  end

  @impl true
  def handle_params(_params, _url, socket) do
    assign(socket, :schemas, fetch_schemas())
  end

  @impl true
  def render(assigns) do
    ~H"""
    <%= if @live_action == :schemas do %>
      <header class="bar">
        <h2>Fragments</h2>
        <.overflow_menu :if={@schemas != []} id="new">
          <:button>
            New
            <.icon name="hero-chevron-down-mini" />
          </:button>
          <.link :for={schema <- @schemas} patch={~p"/#{@site}/fragments/#{schema}/new"}>
            {schema.label}
          </.link>
        </.overflow_menu>
      </header>

      <p :if={@schemas == []} class="placeholder-text">No schemas yet.</p>

      <ul>
        <li :for={schema <- @schemas}>
          <.link patch={~p"/#{@site}/fragments/#{schema}"}>{schema.label}s</.link>
        </li>
      </ul>
    <% end %>

    <%= if @live_action in [:listing, :new] do %>
      <header class="bar">
        <h2>{@schema.label}s</h2>
        <.link patch={~p"/#{@site}/fragments/#{@schema}/new"} class="button">
          new {@schema.label}
        </.link>
      </header>

      <.modal :if={@live_action == :new} on_close={JS.navigate(~p"/#{@site}/fragments/#{@schema}")}>
        <.form :let={f} for={@changeset}>
          <.input
            :for={{name, d} <- @changeset.schema.fields}
            field={f[name]}
            label={d[:label] || labelify(name)}
            class="schema-input"
          />
        </.form>

        <div class="group">
          <.link patch={~p"/#{@site}/fragments/#{@schema}"} class="button">Cancel</.link>
          <button>Create</button>
        </div>
      </.modal>

      <p :if={@schemas == []} class="placeholder-text">No fragments yet.</p>
    <% end %>
    """
  end

  defp labelify(name) do
    name |> to_string() |> String.capitalize()
  end
end
