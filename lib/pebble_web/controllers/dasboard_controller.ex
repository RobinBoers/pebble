defmodule PebbleWeb.DashboardController do
  @moduledoc false
  use PebbleWeb, :controller

  def dashboard(conn, _params) do
    render(conn, :dashboard)
  end
end

defmodule PebbleWeb.DashboardHTML do
  @moduledoc  false
  use PebbleWeb, :html

  embed_templates "templates/*"
end
