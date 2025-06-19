defmodule Pebble.Repo do
  use Ecto.Repo,
    otp_app: :pebble,
    adapter: Ecto.Adapters.Postgres
end
