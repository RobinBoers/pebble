defmodule PebbleWeb.MenuLive do
  @moduledoc false
  use PebbleWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <header class="bar">
      <h2>Menu</h2>
    </header>

    <h3>Entries</h3>

    <h3>Sections</h3>
    """
  end
end
