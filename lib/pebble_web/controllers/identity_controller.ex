defmodule PebbleWeb.IdentityController do
  @moduledoc false
  use PebbleWeb, :controller

  alias Pebble.Repo
  alias Pebble.Settings
  alias Pebble.Changeset

  import Pebble, only: [get_settings: 1]

  def identity(conn, _params) do
    settings = get_settings(conn.assigns.site) || %Settings{site: conn.assigns.site}
    
    conn
    |> assign(:settings, settings)
    |> assign(:changeset, Changeset.new(settings))
    |> render(:editor)
  end

  def edit(conn, %{"settings" => params}) do
    settings = get_settings(conn.assigns.site) || %Settings{site: conn.assigns.site}
    changeset = settings |> Changeset.new() |> Settings.changeset_for(params)

    case upsert_settings(changeset) do
      {:ok, _settings} ->
        send_resp(conn, 204, "")

      {:error, changeset} ->
        conn
        |> assign(:settings, settings)
        |> assign(:changeset, changeset)
        |> render(:editor)
    end
  end

  def schema(conn, _params) do
    settings = get_settings(conn.assigns.site) || %Settings{site: conn.assigns.site}
    
    conn
    |> assign(:settings, settings)
    |> assign(:changeset, Settings.changeset(settings))
    |> render(:schema_editor)
  end

  def edit_schema(conn, %{"settings" => params}) do
    settings = get_settings(conn.assigns.site) || %Settings{site: conn.assigns.site}
    changeset = Settings.changeset(settings, params)

    case upsert_settings(changeset) do
      {:ok, _settings} ->
        send_resp(conn, 204, "")

      {:error, changeset} ->
        conn
        |> assign(:settings, settings)
        |> assign(:changeset, changeset)
        |> render(:schema_editor)
    end
  end

  defp upsert_settings(changeset) do
    case changeset.data.id do
      nil -> Repo.insert(changeset)
      _id -> Repo.update(changeset)
    end
  end
end