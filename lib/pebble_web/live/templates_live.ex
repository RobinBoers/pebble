defmodule PebbleWeb.TemplatesLive do
  @moduledoc false
  use PebbleWeb, :live_view

  alias Pebble.Repo
  alias Pebble.Template

  import Pebble, only: [fetch_templates: 1, fetch_layouts: 1, get_template: 2]

  @decorate_all wrap_noreply()

  @impl true
  def handle_params(_params, _url, socket) do
    socket
    |> assign(:templates, fetch_templates(socket.assigns.site))
    |> assign(:layouts, fetch_layouts(socket.assigns.site))
    |> assign(:changeset, Template.changeset_for(socket.assigns.site))
  end

  @impl true
  def handle_event("create-template", %{"template" => params}, socket) do
    changeset = Template.changeset(%Template{}, params)

    case Repo.insert(changeset) do
      {:ok, template} ->
        push_patch(socket, to: ~p"/#{socket.assigns.site}/templates/#{template.id}")

      {:error, changeset} ->
        assign(socket, :changeset, changeset)
    end
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
            <.input field={f[:type]} label="Type:" type="select" options={["heex", "md", "plain"]} />

            <.inputs_for :let={l} field={f[:template_sites]}>
              <.input field={l[:site_id]} type="hidden" />
              <.input
                field={l[:layout_id]}
                type="select"
                label="Layout:"
                prompt="(none)"
                options={Enum.map(@layouts, &{&1.label, &1.id})}
              />
            </.inputs_for>
          </div>

          <div class="group">
            <.link patch={~p"/#{@site}/templates"} class="button">Cancel</.link>
            <button>Create</button>
          </div>
        </div>
      </.form>
    </.modal>

    <p :if={@templates == []} class="placeholder-text">No templates yet.</p>

    <ul>
      <li :for={template <- @templates}>
        <.link patch={~p"/#{@site}/templates/#{template}"}>{template.label}</.link>
      </li>
    </ul>
    """
  end
end
