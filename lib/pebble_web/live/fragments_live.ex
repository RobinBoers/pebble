defmodule PebbleWeb.FragmentsLive do
  @moduledoc false
  use PebbleWeb, :live_view

  alias Pebble.Schema

  import Pebble, only: [get_schema: 1, fetch_schemas: 0]

  @decorate_all wrap_noreply()

  @impl true
  def handle_params(%{"schema" => id}, _url, socket) do
    case get_schema(id) do
      %Schema{} = schema ->
        socket
        |> assign(:schema, schema)
        |> assign(:schemas, fetch_schemas())

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
        <.schema_form schema={@schema} />
        <div class="group">
          <.link patch={~p"/#{@site}/fragments/#{@schema}"} class="button">Cancel</.link>
          <button>Create</button>
        </div>
      </.modal>

      <p :if={@schemas == []} class="placeholder-text">No fragments yet.</p>
    <% end %>
    """
  end

  attr :schema, Schema, required: true
  attr :rest, :global

  defp schema_form(assigns) do
    ~H"""
    <.schema_input
      :for={{name, props} <- sorted_fields(@schema.fields)}
      name={name} type={props.type} props={props} />
    """
  end

  defp sorted_fields(fields) do
    Enum.sort_by(fields, fn {_name, props} ->
      Map.get(props, :order, 0)
    end)
  end

  attr :name, :string, required: true
  attr :type, :string, required: true
  attr :props, :map, required: true

  defp schema_input(%{type: t} = assigns) when t in ~w(textarea template) do
    ~H"""
    <div class="schema-input">
      <.schema_label name={@name} props={@props} />
      <textarea id={@name} name={@name}></textarea>
    </div>
    """
  end

  defp schema_input(%{type: "boolean"} = assigns) do
    ~H"""
    <div class="schema-input">
      <input name={@name} type="hidden" value="">
      <input id={@name} name={@name} type="checkbox">
      <.schema_label name={@name} props={@props} />
    </div>
    """
  end

  defp schema_input(%{type: "select"} = assigns) do
    ~H"""
    <div class="schema-input">
      <.schema_label name={@name} props={@props} />
      <select id={@name} name={@name}>
        <option :for={opt <- Map.get(@props, :options, [])}>{opt}</option>
      </select>
    </div>
    """
  end

  defp schema_input(assigns) do
    ~H"""
    <div class="schema-input">
      <.schema_label name={@name} props={@props} />
      <input id={@name} name={@name} type={@type}>
    </div>
    """
  end

  attr :name, :string, required: true
  attr :props, :map, required: true

  defp schema_label(%{name: name} = assigns) do
    fallback = name |> Atom.to_string() |> String.capitalize()
    assigns = assign(assigns, :fallback, fallback)

    ~H"""
    <label for={@name}>{Map.get(@props, :label, @fallback)}</label>
    """
  end
end
