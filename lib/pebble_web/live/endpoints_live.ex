defmodule PebbleWeb.EndpointsLive do
  @moduledoc false
  use PebbleWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <p class="placeholder-text">Vik embed here :)</p>
    """
  end
end
