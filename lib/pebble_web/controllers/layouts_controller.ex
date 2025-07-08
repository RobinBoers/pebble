defmodule PebbleWeb.LayoutsController do
  @moduledoc false
  use PebbleWeb, :controller

  alias Pebble.Repo
  alias Pebble.Layout

  import Pebble, only: [
    fetch_layouts: 1,
    get_layout: 2
  ]

  def layouts(conn, _params) do
    conn
    |> mount_layouts()
    |> assign(:changeset, Layout.changeset_for(conn.assigns.site))
    |> render(:listing)
  end

  defp mount_layouts(conn) do
    assign(conn, :layouts, fetch_layouts(conn.assigns.site))
  end

  def new(conn, %{"layout" => params}) do
    changeset = Layout.changeset_for(conn.assigns.site, params)

    case Repo.insert(changeset) do
      {:ok, layout} ->
        redirect(conn, to: ~p"/#{conn.assigns.site}/layouts/#{layout}")

      {:error, changeset} ->
        conn |> mount_layouts() |> render(:listing, changeset: changeset)
    end
  end

  def layout(conn, %{"id" => id}) do
    case get_layout(id, conn.assigns.site) do
      %Layout{} = layout ->
        conn
        |> mount_layouts()
        |> assign(:slayout, layout)
        |> assign(:changeset, Layout.changeset(layout))
        |> render(:editor)

      nil ->
        redirect(conn, to: ~p"/#{conn.assigns.site}/layouts")
    end
  end

  def edit(conn, %{"id" => id, "layout" => params}) do
    layout = Pebble.get_layout(id, conn.assigns.site)
    changeset = Layout.changeset(layout, params)

    case Repo.update(changeset) do
      {:ok, _layout} ->
        send_resp(conn, 204, "")

      {:error, changeset} ->
        conn
        |> mount_layouts()
        |> assign(:slayout, layout)
        |> assign(:changeset, changeset)
        |> render(:editor)
    end
  end

  def delete(conn, %{"id" => id}) do
    layout = Pebble.get_layout(id, conn.assigns.site)

    case Repo.delete(layout) do
      {:ok, _layout} ->
        redirect(conn, to: ~p"/#{conn.assigns.site}/layouts")

      {:error, changeset} ->
        conn
        |> mount_layouts()
        |> assign(:slayout, layout)
        |> assign(:changeset, changeset)
        |> render(:editor)
    end
  end
end