defmodule PebbleWeb.IdentityController do
  @moduledoc false
  use PebbleWeb, :controller

  alias Pebble.Repo
  alias Pebble.Identity
  alias Pebble.Changeset

  import Pebble, only: [get_identity: 1]

  def identity(conn, _params) do
    identity = get_identity(conn.assigns.site) || %Identity{site: conn.assigns.site}
    
    conn
    |> assign(:identity, identity)
    |> assign(:changeset, Changeset.new(identity))
    |> render(:editor)
  end

  def edit(conn, %{"identity" => params}) do
    identity = get_identity(conn.assigns.site) || %Identity{site: conn.assigns.site}
    changeset = identity |> Changeset.new() |> Identity.changeset_for(params)

    case upsert_identity(changeset) do
      {:ok, _identity} ->
        send_resp(conn, 204, "")

      {:error, changeset} ->
        conn
        |> assign(:identity, identity)
        |> assign(:changeset, changeset)
        |> render(:editor)
    end
  end

  def schema(conn, _params) do
    identity = get_identity(conn.assigns.site) || %Identity{site: conn.assigns.site}
    
    conn
    |> assign(:identity, identity)
    |> assign(:changeset, Identity.changeset(identity))
    |> render(:schema_editor)
  end

  def edit_schema(conn, %{"identity" => params}) do
    identity = get_identity(conn.assigns.site) || %Identity{site: conn.assigns.site}
    changeset = Identity.changeset(identity, params)

    case upsert_identity(changeset) do
      {:ok, _identity} ->
        send_resp(conn, 204, "")

      {:error, changeset} ->
        conn
        |> assign(:identity, identity)
        |> assign(:changeset, changeset)
        |> render(:schema_editor)
    end
  end

  defp upsert_identity(changeset) do
    case changeset.data.id do
      nil -> Repo.insert(changeset)
      _id -> Repo.update(changeset)
    end
  end
end