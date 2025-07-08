defmodule PebbleWeb.TemplatesController do
  @moduledoc false
  use PebbleWeb, :controller

  alias Pebble.Repo
  alias Pebble.Template

  import Pebble, only: [
    fetch_templates: 1,
    fetch_layouts: 1,
    get_template: 2
  ]

  @visibility [
    {"Draft", :draft},
    {"Hidden", :hidden},
    {"RSS-only", :rss},
    {"Public", :public}
  ]

  @types [
    {"HTML", :html},
    {"Markdown", :md},
    {"Plain text", :plain}
  ]

  def templates(conn, _params) do
    conn
    |> mount_templates()
    |> assign(:changeset, Template.changeset_for(conn.assigns.site))
    |> render(:listing)
  end

  defp mount_templates(conn) do
    conn
    |> assign(:types, @types)
    |> assign(:visibility, @visibility)
    |> assign(:templates, fetch_templates(conn.assigns.site))
    |> assign(:layouts, fetch_layouts(conn.assigns.site))
  end

  def new(conn, %{"template" => params}) do
    changeset = Template.changeset(%Template{}, params)

    case Repo.insert(changeset) do
      {:ok, template} ->
        redirect(conn, to: ~p"/#{conn.assigns.site}/templates/#{template}")

      {:error, changeset} ->
        conn |> mount_templates() |> render(:listing, changeset: changeset)
    end
  end

  def template(conn, %{"id" => id}) do
    case get_template(id, conn.assigns.site) do
      %Template{} = template ->
        conn
        |> mount_templates()
        |> assign(:template, template)
        |> assign(:changeset, Template.changeset(template))
        |> render(:editor)

      nil ->
        redirect(conn, to: ~p"/#{conn.assigns.site}/templates")
    end
  end

  def edit(conn, %{"id" => id, "template" => params}) do
    template = Pebble.get_template(id, conn.assigns.site)
    changeset = Template.changeset(template, params)

    case Repo.update(changeset) do
      {:ok, template} ->
        send_resp(conn, 204, "")

      {:error, changeset} ->
        conn
        |> mount_templates()
        |> assign(:template, template)
        |> assign(:changeset, changeset)
        |> render(:editor)
    end
  end

  def delete(conn, %{"id" => id}) do
    template = Pebble.get_template(id, conn.assigns.site)

    case Repo.delete(template) do
      {:ok, _template} ->
        redirect(conn, to: ~p"/#{conn.assigns.site}/templates")

      {:error, changeset} ->
        conn
        |> mount_templates()
        |> assign(:template, template)
        |> assign(:changeset, changeset)
        |> render(:editor)
    end
  end
end
