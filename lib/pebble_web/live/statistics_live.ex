defmodule PebbleWeb.StatisticsLive do
  @moduledoc false
  use PebbleWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <header class="bar">
      <h2>Statistics</h2>
    </header>
    """
  end
end
