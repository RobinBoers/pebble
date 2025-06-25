defmodule PebbleWeb.TemplatesLive do
  @moduledoc false
  use PebbleWeb, :live_view

  alias Pebble.Repo
  alias Pebble.Template

  import Pebble, only: [fetch_templates: 1, fetch_layouts: 1, get_template: 2]

  @decorate_all wrap_noreply()

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    case get_template(id, socket.assigns.site) do
      %Template{} = template ->
        socket
        |> assign(:template, template)
        |> assign(:templates, fetch_templates(socket.assigns.site))
        |> assign(:layouts, fetch_layouts(socket.assigns.site))
        |> assign(:changeset, Template.changeset(template))

      nil ->
        push_patch(socket, to: ~p"/#{socket.assigns.site}/templates")
    end
  end

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
  def handle_event("save-template", %{"template" => params}, socket) do
    changeset = Template.changeset(socket.assigns.template, params)

    case Repo.update(changeset) do
      {:ok, template} ->
        push_patch(socket, to: ~p"/#{socket.assigns.site}/templates/#{template.id}")

      {:error, changeset} ->
        dbg(changeset)
        assign(socket, :changeset, changeset)
    end
  end

  @impl true
  def handle_event("delete-template", _params, socket) do
    case Repo.delete(socket.assigns.template) do
      {:ok, template} -> 
        socket
        |> assign(:template, template)
        |> assign(:changeset, Template.changeset(template))

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
        <.inputs_for :let={s} field={f[:linked_sites]}>
          <.input field={s[:site_id]} type="hidden" />
          <.input field={f[:label]} label="Label" required />
          <.input field={s[:route]} label="Route" required />

          <div class="lowbar">
            <div class="row">
              <.input
                field={s[:layout_id]}
                type="select"
                label="Layout:"
                prompt="(none)"
                options={Enum.map(@layouts, &{&1.label, &1.id})}
              />
              <.input
                field={f[:type]}
                label="Render as:"
                type="select"
                options={Template.types()}
              />
            </div>

            <div class="group">
              <.link patch={~p"/#{@site}/templates"} class="button">Cancel</.link>
              <button>Create</button>
            </div>
          </div>
        </.inputs_for>
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

  @impl true
  def render(assigns) do
    ~H"""
    <.form
      :let={f} for={@changeset}
      phx-submit="save-template"
      phx-change="save-template"
      phx-debounce="blur"
    >
      <.inputs_for :let={s} field={f[:linked_sites]}>
        <%= if s[:site_id].value == @site.id do %>
          <header>
            <.input field={s[:site_id]} type="hidden" />
            <.input field={s[:route]} placeholder="Route" class="mb-[0.2em]" />
            <div class="bar">
              <.input field={f[:label]} title placeholder="Label" />
              <button>Save</button>
            </div>
          </header>
          <.input field={f[:content]} type="textarea" />
          <div class="options">
            <button phx-click="delete-template" data-confirm="Are you sure? This will permanently and irreversibly delete this template and deactivate its route, which will immediately break all URLs pointing to it. This action cannot be undone.">Delete</button>
  
            <.input
              field={s[:layout_id]}
              type="select"
              label="Layout:"
              prompt="(none)"
              options={Enum.map(@layouts, &{&1.label, &1.id})}
            />

            <.input
              field={s[:type]}
              label="Render as:"
              type="select"
              options={Template.types()}
            />
          </div>
        <% else %>
          <.input field={s[:site_id]} type="hidden" />
          <.input field={s[:layout_id]} type="hidden" />
        <% end %>
      </.inputs_for>
    </.form>
    """
  end
end
