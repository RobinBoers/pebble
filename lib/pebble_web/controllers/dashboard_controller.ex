defmodule PebbleWeb.DashboardController do
  @moduledoc false
  use PebbleWeb, :controller

  def dashboard(conn, _params) do
    render(conn, :dashboard)
  end
end
