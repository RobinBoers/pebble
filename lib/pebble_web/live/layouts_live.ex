defmodule PebbleWeb.LayoutsLive do
  @moduledoc false
  use PebbleWeb, :live_view

  alias Pebble.Repo
  alias Pebble.Site
  alias Pebble.Layout

  import Ecto.Query

  @decorate_all wrap_noreply()

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    case get_layout(id, socket.assigns.site) do
      %Layout{} = layout ->
        socket
        |> assign(:slayout, layout) # because layout is apparently a reserved key
        |> assign(:changeset, Layout.changeset(layout))

      nil ->
        push_patch(socket, to: ~p"/#{socket.assigns.site}/layouts")
    end
  end

  @impl true
  def handle_params(_params, _url, socket) do
    socket
    |> assign(:layouts, fetch_layouts(socket.assigns.site))
    |> assign(:changeset, Layout.changeset())
  end

  # TODO(robin): wrap these in another module/public API?
  # because doing raw queries in the LiveView seems dirty...

  defp get_layout(id, %Site{id: site_id}) do
    Repo.one(from l in Layout,
      where: l.id == ^id and l.site_id == ^site_id)
  end

  defp fetch_layouts(%Site{id: site_id}) do
    Repo.all(from l in Layout,
      where: l.site_id == ^site_id,
      order_by: [desc: l.updated_at])
  end

  @impl true
  def handle_event("create-layout", %{"layout" => params}, socket) do
    changeset = Layout.changeset(%Layout{site: socket.assigns.site}, params)

    case Repo.insert(changeset) do
      {:ok, layout} ->
        push_patch(socket, to: ~p"/#{socket.assigns.site}/layouts/#{layout}")

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

    <.form
      :if={@live_action == :new} 
      :let={f} for={@changeset}
      class="modal"
      phx-submit="create-layout"
    >
      <.input field={f[:label]} label="Label" required />

      <div class="group">
        <button>Create</button>
        <.link patch={~p"/#{@site}/layouts"} class="button">Cancel</.link>
      </div>
    </.form>

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
    <h1>{@slayout.label}</h1>
    """
  end
end
