defmodule PebbleWeb.ContactsLive do
  @moduledoc false
  use PebbleWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <header class="bar">
      <h2>Contacts</h2>
      <a href={~p"/#{@site}/contacts/new"} class="button">New contact</a>
    </header>

    <p class="placeholder-text">No contacts yet.</p>
    """
  end
end
