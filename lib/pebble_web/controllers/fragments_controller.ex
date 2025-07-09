defmodule PebbleWeb.FragmentsController do
  @moduledoc false
  use PebbleWeb, :controller

  alias Pebble.Repo
  alias Pebble.Schema
  alias Pebble.Fragment
  alias Pebble.Changeset

  import Pebble, only: [
    get_schema: 2,
    get_fragment: 3,
    fetch_fragments: 2
  ]

  def fragments(conn, %{"schema" => schema_id}) do
    case get_schema(schema_id, conn.assigns.site) do
      %Schema{} = schema ->
        conn
        |> mount_fragments(schema)
        |> render(:listing)

      nil ->
        redirect(conn, to: ~p"/#{conn.assigns.site}/templates")
    end
  end

  def new(conn, %{"schema" => schema_id, "fragment" => params}) do
    schema = get_schema(schema_id, conn.assigns.site)
    changeset = schema |> Changeset.new() |> Fragment.changeset_for(params)

    case Repo.insert(changeset) do
      {:ok, fragment} ->
        redirect(conn, to: ~p"/#{conn.assigns.site}/s/#{schema}/#{fragment}")

      {:error, _changeset} ->
        conn
        |> mount_fragments(schema)
        |> render(:listing)
    end
  end

  def fragment(conn, %{"schema" => schema_id, "id" => id}) do
    case get_fragment(id, schema_id, conn.assigns.site) do
      %Fragment{} = fragment ->
        conn
        |> assign(:fragment, fragment)
        |> assign(:schema, fragment.schema)
        |> assign(:changeset, Changeset.new(fragment))
        |> render(:editor)

      nil ->
        redirect(conn, to: ~p"/#{conn.assigns.site}/s/#{schema_id}")
    end
  end

  def edit(conn, %{"schema" => schema_id, "id" => id, "fragment" => params}) do
    fragment = get_fragment(id, schema_id, conn.assigns.site)
    changeset = fragment |> Changeset.new() |> Fragment.changeset_for(params)

    case Repo.update(changeset) do
      {:ok, _fragment} ->
        send_resp(conn, 204, "")

      {:error, _changeset} ->
        conn
        |> assign(:fragment, fragment)
        |> assign(:schema, fragment.schema)
        |> assign(:changeset, changeset)
        |> render(:editor)
    end
  end

  def delete(conn, %{"schema" => schema_id, "id" => id}) do
    fragment = get_fragment(id, schema_id, conn.assigns.site)

    case Repo.delete(fragment) do
      {:ok, _fragment} ->
        redirect(conn, to: ~p"/#{conn.assigns.site}/s/#{schema_id}")

      {:error, _changeset} ->
        conn
        |> assign(:fragment, fragment)
        |> assign(:schema, fragment.schema)
        |> assign(:changeset, Changeset.new(fragment))
        |> render(:editor)
    end
  end

  defp mount_fragments(conn, schema) do
    conn
    |> assign(:schema, schema)
    |> assign(:fragments, fetch_fragments(schema.id, conn.assigns.site))
    |> assign(:changeset, Changeset.new(schema))
  end
end