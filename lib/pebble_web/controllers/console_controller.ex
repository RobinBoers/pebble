defmodule PebbleWeb.ConsoleController do
  @moduledoc false
  use PebbleWeb, :controller

  def endpoints(conn, _params) do
    render(conn, :placeholder)
  end

  def shell(conn, _params) do
    render(conn, :placeholder)
  end

  def logs(conn, _params) do
    render(conn, :placeholder)
  end
end