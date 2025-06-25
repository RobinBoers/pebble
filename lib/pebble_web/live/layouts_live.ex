defmodule PebbleWeb.LayoutsLive do
  @moduledoc false
  use PebbleWeb, :live_view

  alias Pebble.Repo
  alias Pebble.Layout

  import Pebble, only: [fetch_layouts: 1, get_layout: 2]

  @decorate_all wrap_noreply()

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    case get_layout(id, socket.assigns.site) do
      %Layout{} = layout ->
        socket
        |> assign(:slayout, layout) # because layout is apparently a reserved key
        |> assign(:layouts, fetch_layouts(socket.assigns.site))
        |> assign(:changeset, Layout.changeset(layout))

      nil ->
        push_patch(socket, to: ~p"/#{socket.assigns.site}/layouts")
    end
  end

  @impl true
  def handle_params(_params, _url, socket) do
    socket
    |> assign(:layouts, fetch_layouts(socket.assigns.site))
    |> assign(:changeset, Layout.changeset_for(socket.assigns.site))
  end

  @impl true
  def handle_event("create-layout", %{"layout" => params}, socket) do
    changeset = Layout.changeset_for(socket.assigns.site, params)

    case Repo.insert(changeset) do
      {:ok, layout} ->
        push_patch(socket, to: ~p"/#{socket.assigns.site}/layouts/#{layout}")

      {:error, changeset} ->
        assign(socket, :changeset, changeset)
    end
  end

  @impl true
  def handle_event("save-layout", %{"layout" => params}, socket) do
    changeset = Layout.changeset(%Layout{}, params)

    case Repo.update(changeset) do
      {:ok, layout} ->
        push_patch(socket, to: ~p"/#{socket.assigns.site}/layouts/#{layout}")

      {:error, changeset} ->
        assign(socket, :changeset, changeset)
    end
  end

  @impl true
  def handle_event("delete-layout", _params, socket) do
    case Repo.delete(socket.assigns.slayout) do
      {:ok, _layout} -> 
        push_patch(socket, to: ~p"/#{socket.assigns.site}/layouts")

      {:error, changeset} ->
        assign(socket, :changeset, changeset)
    end
  end

  @impl true
  def render(assigns) when assigns.live_action in [:layouts, :new] do
    ~H"""
    <header class="bar">
      <h2>Layouts</h2>
      <.link patch={~p"/#{@site}/layouts/new"} class="button">New layout</.link>
    </header>

    <.modal :if={@live_action == :new} on_close={JS.navigate(~p"/#{@site}/layouts")}>
      <.form :let={f} for={@changeset} phx-submit="create-layout">
        <.input field={f[:label]} label="Label" required />

        <div class="lowbar">
          <div class="row">
            <.input
              field={f[:extends_id]}
              label="Extends:"
              type="select"
              prompt="(none)"
              options={Enum.map(@layouts, &{&1.label, &1.id})}
            />
          </div>

          <div class="group">
            <.link patch={~p"/#{@site}/layouts"} class="button">Cancel</.link>
            <button>Create</button>
          </div>
        </div>
      </.form>
    </.modal>

    <p :if={@layouts == []} class="placeholder-text">No layouts yet.</p>

    <ul>
      <li :for={layout <- @layouts}>
        <.link patch={~p"/#{@site}/layouts/#{layout}"}>{layout.label}</.link>
      </li>
    </ul>
    """
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.form :let={f} for={@changeset} phx-submit="save-layout">
      <header class="bar">
        <.input field={f[:label]} title placeholder="Label" />
        <button>Save</button>
      </header>
      <.input field={f[:content]} type="textarea" />
      <div class="options">
        <button phx-click="delete-layout" data-confirm="Are you sure? This will permanently and irreversibly delete this layout and render all templates depending on it broken. This action cannot be undone.">Delete</button>
        <.input
          field={f[:extends_id]}
          label="Extends:"
          type="select"
          prompt="(nothing)"
          options={Enum.map(@layouts, &{&1.label, &1.id})}
        />
      </div>
    </.form>
    """
  end
end
