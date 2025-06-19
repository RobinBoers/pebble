defmodule PebbleWeb.SettingsLive do
  @moduledoc false
  use PebbleWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <header class="bar">
      <h2>Settings</h2>
    </header>
    """
  end
end
