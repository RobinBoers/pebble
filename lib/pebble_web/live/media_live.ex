defmodule PebbleWeb.MediaLive do
  @moduledoc false
  use PebbleWeb, :live_view

  @decorate_all wrap_noreply()

  @impl true
  def mount(_params, _session, socket) do
    socket
    |> assign(:uploaded_files, [])
    |> allow_upload(:assets, accept: ~w(.jpg .jpeg .png .gif .webp))
  end

  @impl true
  def render(assigns) when assigns.live_action == :media do
    ~H"""
    <header class="bar">
      <h2>Media</h2>
      <p class="group">
        <.link patch={~p"/#{@site}/media/upload"} class="button">Upload</.link>
      </p>
    </header>

    <h3>Assets</h3>

    <p class="placeholder-text">No assets yet.</p>
    """
  end

  @impl true
  def render(assigns) when assigns.live_action == :upload do
    ~H"""
    <header class="bar">
      <h2>Upload assets</h2>
      <p class="group">
        <button form="upload-form">Upload</button>
      </p>
    </header>

    <form id="upload-form" phx-hook="Uploads" phx-change="validate-uploads" phx-submit="process-uploads">
      <.live_file_input upload={@uploads.assets} />
    </form>
    """
  end
end
