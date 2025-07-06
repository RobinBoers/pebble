defmodule PebbleWeb.DashboardController do
  @moduledoc false
  use PebbleWeb, :controller

  def mount_site(conn, _opts) do
    %Plug.Conn{params: %{"site" => hostname}} = conn

    case Enum.find(sites, &(&1.hostname == hostname)) do
      %Site{} = site -> mount_navigation(conn, sites, site)
      nil -> redirect_to_fallback(conn, sites)
    end
  end

  defp mount_navigation(socket, sites, site) do
    

    conn
    |> assign(:site, site)
    |> assign(:sites, sites)
    |> assign(socket, :menu_items, [
      %{key: "dashboard", title: "Dashboard", path: ~p"/#{site}"},
      %{key: "records", title: "Records", children: records_children(site)},
      %{key: "design", title: "Design", children: design_children(site)}
    ])
  end

  defp records_children(site) do
    [%{title: "Templates", path: ~p"/#{site}/templates"} | records_schema_children(site)]
  end

  defp records_schema_children(site) do
    for schema <- Pebble.list_schemas(site) do
      %{title: schema.name, path: ~p"/#{site}/s/#{schema}"}
    end
  end

  defp design_children(site) do
    [
      %{title: "Layouts", path: ~p"/#{site}/layouts"}
    ]
  end

  defp redirect_to_fallback(socket, [fallback | _]) do
    {:halt, push_navigate(socket, to: ~p"/#{fallback}")}
  end

  defp redirect_to_fallback(_socket, []) do
    raise "no sites available :("
  end

  def dashboard(conn, _params) do
    render(conn, :dashboard)
  end
end

defmodule PebbleWeb.DashboardHTML do
  @moduledoc  false
  use PebbleWeb, :html

  embed_templates "templates/*"
end
