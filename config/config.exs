import Config

config :pebble,
  ecto_repos: [Pebble.Repo],
  generators: [timestamp_type: :utc_datetime]

config :pebble, PebbleWeb.Endpoint,
  url: [host: "pebble"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: PebbleWeb.ErrorHTML, json: PebbleWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Pebble.PubSub,
  live_view: [signing_salt: "d64Xfw6S"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, JSON

config :pythonx, :uv_init,
  pyproject_toml: """
  [project]
  name = "pebble"
  version = "#{Mix.Project.config()[:version]}"
  requires-python = "==3.13.*"
  dependencies = [
    "Jinja2==3.1.6"
  ]
  """

import_config "#{config_env()}.exs"
