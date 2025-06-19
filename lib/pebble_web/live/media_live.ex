defmodule PebbleWeb.MediaLive do
  @moduledoc false
  use PebbleWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <header class="bar">
      <h2>Media</h2>
      <p class="group">
        <a href="/media/upload" class="button">Upload asset</a>
        <a href="/media/new" class="button">New post</a>
      </p>
    </header>

    <h3>Assets</h3>

    <p class="placeholder-text">No assets yet.</p>
    """
  end
end
