defmodule PebbleWeb.TemplatesLive do
  @moduledoc false
  use PebbleWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <header class="bar">
      <h2>Templates</h2>
      <a href={~p"/#{@site}/templates/new"} class="button">New template</a>
    </header>

    <p class="placeholder-text">No templates yet.</p>
    """
  end
end
