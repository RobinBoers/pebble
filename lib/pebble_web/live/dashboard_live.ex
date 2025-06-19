defmodule PebbleWeb.DashboardLive do
  @moduledoc false
  use PebbleWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <header class="bar">
      <h2>Your home on the Web.</h2>
    </header>

    <p>Welcome to pebble, a simple but powerful tool to publish words on the Web.</p>

    <p><br></p>

    <h3>Quick actions</h3>

    <ul>
      <li><a href="/fragments">Fragments</a></li>
      <li><a href="/templates">Templates</a></li>
      <li><a href="/endpoints">Endpoints</a></li>
      <li><a href="/layouts">Layouts</a></li>
      <li><a href="/media">Media</a></li>
      <li><a href="/contacts">Contacts</a></li>
      <li><a href="/stats">Menu</a></li>
      <li><a href="/stats">Statistics</a></li>
    </ul>
    """
  end
end
