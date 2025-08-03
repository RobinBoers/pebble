defmodule Pebble.Application do
  @moduledoc false
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Jinja,
      PebbleWeb.Telemetry,
      Pebble.Repo,
      {Phoenix.PubSub, name: Pebble.PubSub},
      PebbleWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Pebble.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    PebbleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
