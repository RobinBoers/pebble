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
      <li><.link navigate={~p"/#{@site}/fragments/new"}>Write anything. Write everything.</.link></li>
      <li><.link navigate={~p"/#{@site}/media/upload"}>Upload memories</.link></li>
      <li><.link href={"https://#{@site}"} target="_blank">Go to {@site} →</.link></li>
    </ul>
    """
  end
end
