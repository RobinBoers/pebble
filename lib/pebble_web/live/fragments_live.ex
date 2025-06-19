defmodule PebbleWeb.FragmentsLive do
  @moduledoc false
  use PebbleWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <header class="bar">
      <h2>Fragments</h2>
      <a href={~p"/fragments/new"} class="button">New fragments</a>
    </header>

    <p class="placeholder-text">No fragments yet.</p>
    """
  end
end
