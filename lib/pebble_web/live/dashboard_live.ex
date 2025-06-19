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
      <li><.link navigate={~p"/fragments/new"}>Write anything. Write everything.</.link></li>
      <li><.link navigate={~p"/media/upload"}>Upload memories</.link></li>
      <li><.link href="#" target="_blank">Go to geheimesite.nl →</.link></li>
    </ul>
    """
  end
end
