defmodule PebbleWeb.SetupController do
  @moduledoc false
  use PebbleWeb, :controller

  def setup(conn, _params) do
    case Pebble.fetch_sites() do
      [] -> raise "no sites available :("
      [s | _] -> redirect(conn, to: ~p"/#{s}")
    end
  end
end
