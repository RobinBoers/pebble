defmodule PebbleWeb.LayoutsLive do
  @moduledoc false
  use PebbleWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <header class="bar">
      <h2>Layouts</h2>
      <a href={~p"/layouts/new"} class="button">New layout</a>
    </header>

    <p class="placeholder-text">No layouts yet.</p>
    """
  end
end
