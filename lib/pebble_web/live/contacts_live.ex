defmodule PebbleWeb.ContactsLive do
  @moduledoc false
  use PebbleWeb, :live_view

  alias Pebble.Repo
  alias Pebble.Contact

  import Pebble, only: [get_contact: 1, fetch_contacts: 0]

  @decorate_all wrap_noreply()

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    case get_contact(id) do
      %Contact{} = contact ->
        socket
        |> assign(:contact, contact)
        |> assign(:contacts, fetch_contacts())
        |> assign(:changeset, Contact.changeset(contact))

      nil ->
        push_patch(socket, to: ~p"/#{socket.assigns.site}/contacts")
    end
  end

  @impl true
  def handle_params(_params, _url, socket) do
    socket
    |> assign(:contacts, fetch_contacts())
    |> assign(:changeset, Contact.changeset())
  end

  @impl true
  def handle_event("create-contact", %{"contact" => params}, socket) do
    changeset = Contact.changeset(%Contact{}, params)

    case Repo.insert(changeset) do
      {:ok, contact} ->
        push_patch(socket, to: ~p"/#{socket.assigns.site}/contacts/#{contact}", replace: true)

      {:error, changeset} ->
        assign(socket, :changeset, changeset)
    end
  end

  @impl true
  def handle_event("save-contact", %{"contact" => params}, socket) do
    changeset = Contact.changeset(socket.assigns.contact, params)

    case Repo.update(changeset) do
      {:ok, _contact} ->
        push_patch(socket, to: ~p"/#{socket.assigns.site}/contacts")

      {:error, changeset} ->
        assign(socket, :changeset, changeset)
    end
  end

  @impl true
  def handle_event("delete-contact", _params, socket) do
    case Repo.delete(socket.assigns.contact) do
      {:ok, _contact} ->
        push_patch(socket, to: ~p"/#{socket.assigns.site}/contacts")

      {:error, changeset} ->
        assign(socket, :changeset, changeset)
    end
  end

  @impl true
  def render(assigns) when assigns.live_action in [:contacts, :new] do
    ~H"""
    <header class="bar">
      <h2>Contacts</h2>
      <.link patch={~p"/#{@site}/contacts/new"} class="button">New contact</.link>
    </header>

    <.modal :if={@live_action == :new} on_close={JS.navigate(~p"/#{@site}/contacts")}>
      <.form :let={f} for={@changeset} phx-submit="create-contact">
        <.input field={f[:handle]} type="text" label="Handle" placeholder="@dreamwastaken" required />
        <.input field={f[:url]} type="url" label="URL" placeholder="https://example.com" required />
        <.input field={f[:email]} type="email" label="Email" placeholder="dream@example.com" required />

        <.input
          field={f[:notify]}
          type="checkbox"
          label="Send them an email when I @mention them."
        />

        <div class="group">
          <.link patch={~p"/#{@site}/contacts"} class="button">Cancel</.link>
          <button>Create</button>
        </div>
      </.form>
    </.modal>

    <p :if={@contacts == []} class="placeholder-text">No contacts yet.</p>

    <ul>
      <li :for={contact <- @contacts}>
        <.link patch={~p"/#{@site}/contacts/#{contact}"}>@{contact.handle}</.link>
        <span class="actions">
          <.link href={"mailto:#{contact.email}"}>
            Message
          </.link>
          <.link href={contact.url}>
            Visit →
          </.link>
        </span>
      </li>
    </ul>
    """
  end

  @impl true
  def render(assigns) do
    ~H"""
    <header class="bar">
      <h2>Edit contact</h2>
    </header>

    <.form
      class="form"
      :let={f} for={@changeset}
      phx-submit="save-contact"
    >
      <.input field={f[:handle]} type="text" label="Handle" placeholder="@dreamwastaken" required />
      <.input field={f[:url]} type="url" label="Domain" placeholder="https://example.com" required />
      <.input field={f[:email]} type="email" label="Email" placeholder="dream@example.com" required />

      <.input
        field={f[:notify]}
        type="checkbox"
        label="Send them an email when I @mention them."
      />

      <div class="lowbar">
        <button phx-click="delete-contact" data-confirm="Are you sure? This will permanently and irreversibly delete this layout and render all templates depending on it broken. This action cannot be undone.">Delete</button>

        <div class="group">
          <.link patch={~p"/#{@site}/contacts"} class="button">Cancel</.link>
          <button>Save</button>
        </div>
      </div>
    </.form>
    """
  end
end
