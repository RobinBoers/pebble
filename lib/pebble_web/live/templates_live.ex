defmodule PebbleWeb.TemplatesLive do
  @moduledoc false
  use PebbleWeb, :live_view

  alias Pebble.Repo
  alias Pebble.Site
  alias Pebble.Template

  import Ecto.Query

  @decorate_all wrap_noreply()

  @impl true
  def handle_params(_params, _url, socket) do
    socket
    |> assign(:templates, fetch_templates(socket.assigns.site))
    |> assign(:changeset, Template.changeset())
  end

  defp fetch_templates(%Site{id: site_id}) do
    Repo.all(from t in Template,
      join: s in assoc(t, :sites),
      where: s.id == ^site_id,
      order_by: [desc: t.updated_at])
  end

  @impl true
  def render(assigns) when assigns.live_action in [:templates, :new] do
    ~H"""
    <header class="bar">
      <h2>Templates</h2>
      <.link patch={~p"/#{@site}/templates/new"} class="button">New template</.link>
    </header>

    <.modal :if={@live_action == :new} on_close={JS.navigate(~p"/#{@site}/templates")}>
      <.form :let={f} for={@changeset} phx-submit="create-template">
        <.input field={f[:label]} label="Label" required />
        <.input field={f[:route]} label="Route" required />

        <div class="bar">
          <div class="row">
            <.input field={f[:type]} label="Type" type="select" options={["heex", "md", "plain"]} />
          </div>

          <div class="group">
            <.link patch={~p"/#{@site}/templates"} class="button">Cancel</.link>
            <button>Create</button>
          </div>
        </div>
      </.form>
    </.modal>

    <p class="placeholder-text">No templates yet.</p>
    """
  end
end
