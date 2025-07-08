defmodule PebbleWeb.SchemasController do
  @moduledoc false
  use PebbleWeb, :controller

  alias Pebble.Repo
  alias Pebble.Schema

  import Pebble, only: [
    fetch_schemas: 1,
    get_schema: 2
  ]

  @listings [
    {"Table", :table},
    {"Inline", :inline}
  ]

  def schemas(conn, _params) do
    conn
    |> mount_schemas()
    |> assign(:changeset, Schema.changeset_for(conn.assigns.site))
    |> render(:listing)
  end

  defp mount_schemas(conn) do
    assign(conn, :schemas, fetch_schemas(conn.assigns.site))
  end

  def new(conn, %{"schema" => params}) do
    changeset = Schema.changeset_for(conn.assigns.site, params)

    case Repo.insert(changeset) do
      {:ok, schema} ->
        redirect(conn, to: ~p"/#{conn.assigns.site}/schemas/#{schema}")

      {:error, changeset} ->
        conn |> mount_schemas() |> render(:listing, changeset: changeset)
    end
  end

  def schema(conn, %{"id" => id}) do
    case get_schema(id, conn.assigns.site) do
      %Schema{} = schema ->
        conn
        |> mount_schemas()
        |> assign(:schema, schema)
        |> assign(:listings, @listings)
        |> assign(:changeset, Schema.changeset(schema))
        |> render(:editor)

      nil ->
        redirect(conn, to: ~p"/#{conn.assigns.site}/schemas")
    end
  end

  def edit(conn, %{"id" => id, "schema" => params}) do
    schema = Pebble.get_schema(id, conn.assigns.site)
    changeset = Schema.changeset(schema, params)

    case Repo.update(changeset) do
      {:ok, schema} ->
        send_resp(conn, 204, "")

      {:error, changeset} ->
        conn
        |> mount_schemas()
        |> assign(:schema, schema)
        |> assign(:listings, @listings)
        |> assign(:changeset, changeset)
        |> render(:editor)
    end
  end

  def delete(conn, %{"id" => id}) do
    schema = Pebble.get_schema(id, conn.assigns.site)

    case Repo.delete(schema) do
      {:ok, _schema} ->
        redirect(conn, to: ~p"/#{conn.assigns.site}/schemas")

      {:error, changeset} ->
        conn
        |> mount_schemas()
        |> assign(:schema, schema)
        |> assign(:listings, @listings)
        |> assign(:changeset, changeset)
        |> render(:editor)
    end
  end
end