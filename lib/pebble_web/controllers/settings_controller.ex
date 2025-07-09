defmodule PebbleWeb.SettingsController do
  @moduledoc false
  use PebbleWeb, :controller

  def settings(conn, _params) do
    render(conn, :placeholder)
  end
end