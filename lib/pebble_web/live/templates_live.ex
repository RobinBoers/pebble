defmodule PebbleWeb.TemplatesLive do
  @moduledoc false
  use PebbleWeb, :live_view

  alias Pebble.Repo
  alias Pebble.Template
  alias Pebble.Context

  import Pebble, only: [fetch_templates: 1, fetch_layouts: 1, get_template: 2]

  @decorate_all wrap_noreply()

  @visibility [
    {"Draft", :draft},
    {"Hidden", :hidden},
    {"RSS-only", :rss},
    {"Public", :public}
  ]

  @types [
    {"HEEx", :heex},
    {"Markdown", :md},
    {"Plain text", :plain}
  ]

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    case get_template(id, socket.assigns.site) do
      %Template{} = template ->
        socket
        |> assign(:template, template)
        |> assign(:templates, fetch_templates(socket.assigns.site))
        |> assign(:layouts, fetch_layouts(socket.assigns.site))
        |> assign(:changeset, Template.changeset(template))
        |> assign(visibility: @visibility, types: @types)
        |> assign_add_changeset(Context.changeset_for(template))

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
    |> assign(visibility: @visibility, types: @types)
  end

  defp other_sites(template, site) do
    Enum.filter(template.sites, &(&1.id != site.id))
  end

  defp assign_add_changeset(socket, changeset) do
    socket
    |> assign(:add_changeset, changeset)
    |> assign(:add_form, to_form(changeset))
    |> assign_new(:add_layouts, fn -> [] end)
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
  def handle_event("choose-site", %{"context" => params}, socket) do
    changeset = Context.changeset_for(socket.assigns.template, params)

    socket
    |> assign(:add_layouts, fetch_layouts(params["site_id"]))
    |> assign_add_changeset(changeset)
  end

  @impl true
  def handle_event("add-site", %{"context" => params}, socket) do
    changeset = Context.changeset_for(socket.assigns.template, params)

    case Repo.insert(changeset) do
      {:ok, context} ->
        push_patch(socket, to: ~p"/#{context.site_id}/templates/#{socket.assigns.template}")

      {:error, changeset} ->
        assign_add_changeset(socket, changeset)
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
              <.input field={f[:type]} label="Render as:" type="select" options={@types} />
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
      :let={f}
      class="editor"
      for={@changeset}
      phx-submit="save-template"
      phx-change="save-template"
      phx-debounce="blur"
    >
      <.inputs_for :let={s} field={f[:linked_sites]}>
        <%= if to_string(s[:site_id].value) == to_string(@site.id) do %>
          <div class="plane">
            <header>
              <.input field={s[:site_id]} type="hidden" />
              <.input field={s[:route]} placeholder="Route" class="mb-[0.2em]" />
              <div class="bar">
                <.input field={f[:label]} title placeholder="Label" />
                <code class="id">{@template.id}</code>
              </div>
            </header>

            <.add_modal
              :if={@live_action == :add && length(@template.sites) == 1}
              site={@site}
              template={@template}
              form={@add_form}
              layouts={@add_layouts}
              sites={@sites}
            />

            <.input field={f[:content]} type="textarea" />
          </div>

          <aside>
            <div class="vgroup">
              <button class="save">
                <.icon name="hero-server" /> Save & deploy
              </button>
              <.input
                field={f[:visibility]}
                type="select"
                display="block"
                class="visibility"
                options={@visibility}
              />
            </div>

            <.input
              field={s[:layout_id]}
              type="select"
              label="Extends layout"
              prompt="(none)"
              display="block"
              options={Enum.map(@layouts, &{&1.label, &1.id})}
            />

            <.input field={f[:type]} label="Render as" type="select" display="block" options={@types} />

            <section :if={length(@template.sites) > 1} class="other-sites">
              <header>
                <h3>Available sites</h3>
                <button
                  :if={length(@template.sites) < length(@sites)}
                  phx-click={JS.navigate(~p"/#{@site}/templates/#{@template}/add")}
                >
                  <.icon name="hero-plus" class="size-3" />
                </button>
              </header>

              <.add_modal
                :if={@live_action == :add}
                site={@site}
                template={@template}
                form={@add_form}
                layouts={@add_layouts}
                sites={@sites}
              />

              <ul>
                <li :for={site <- @template.sites}>
                  <.link
                    navigate={~p"/#{site}/templates/#{@template}"}
                    class={site.id == @site.id && "selected"}
                  >
                    {site}
                  </.link>
                </li>
              </ul>
            </section>

            <div class="actions">
              <button
                :if={length(@sites) > 1 and length(@template.sites) == 1}
                phx-click={JS.navigate(~p"/#{@site}/templates/#{@template}/add")}
              >
                Add to another site
              </button>

              <button
                phx-click="delete-template"
                data-confirm="Are you sure? This will permanently and irreversibly delete this template and deactivate its route, which will immediately break all URLs pointing to it. This action cannot be undone."
                class="delete"
              >
                Delete
              </button>
            </div>
          </aside>
        <% else %>
          <.input field={s[:site_id]} type="hidden" />
          <.input field={s[:route]} type="hidden" />
          <.input field={s[:layout_id]} type="hidden" />
        <% end %>
      </.inputs_for>
    </.form>

    <.form
      id="add-form"
      for={@add_form}
      phx-change="choose-site"
      phx-submit="add-site"
      phx-debounce="blur"
    >
    </.form>
    """
  end

  attr :site, :string, required: true
  attr :template, :string, required: true
  attr :form, :string, required: true
  attr :layouts, :string, required: true
  attr :sites, :string, required: true

  defp add_modal(assigns) do
    ~H"""
    <.modal on_close={JS.navigate(~p"/#{@site}/templates/#{@template}")}>
      <.input
        form="add-form"
        field={@form[:site_id]}
        type="select"
        label="Make this template available to:"
        prompt="(select site)"
        options={Enum.map(@sites -- @template.sites, &{&1.hostname, &1.id})}
      />

      <%= if @form[:site_id].value not in [nil, ""] do %>
        <.input form="add-form" field={@form[:route]} type="text" label="Route" />
        <.input
          form="add-form"
          field={@form[:layout_id]}
          type="select"
          label="Extends layout"
          prompt="(none)"
          options={Enum.map(@layouts, &{&1.label, &1.id})}
        />
      <% end %>

      <div class="group">
        <.link patch={~p"/#{@site}/templates/#{@template}"} class="button">Cancel</.link>
        <button :if={@form[:site_id].value not in [nil, ""]} form="add-form">Add</button>
      </div>
    </.modal>
    """
  end
end
