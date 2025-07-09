defmodule PebbleWeb.Navigation do
  @moduledoc false
  use PebbleWeb, :plug

  alias Pebble.Site

  def mount_site(conn, _opts) do
    %Plug.Conn{params: %{"site" => hostname}} = conn
    sites = Pebble.fetch_sites()

    case Enum.find(sites, &(&1.hostname == hostname)) do
      %Site{} = site -> mount_navigation(conn, sites, site)
      nil -> redirect_to_fallback(conn, sites)
    end
  end

  defp mount_navigation(conn, sites, site) do
    conn
    |> assign(:site, site)
    |> assign(:sites, sites)
    |> assign_menu_tabs()
  end

  defp assign_menu_tabs(conn) do
    tabs = menu_tabs(conn.assigns.site)
    {tab, page} = find_selected_page(conn, tabs)

    conn
    |> assign(:menu_tabs, tabs)
    |> assign(:menu_children, tab.children)
    |> assign(:current_tab, tab)
    |> assign(:current_page, page)
    |> assign(:page_title, page.title)
  end

  defp find_selected_page(conn, tabs) do
    Enum.find_value(Enum.reverse(tabs), fn tab ->
      if route_match?(conn, tab) do
        {tab, List.first(tab.children, tab)}
      else
        Enum.find_value(tab.children, fn child ->
          route_match?(conn, child) && {tab, child}
        end)
      end
    end)
  end

  defp route_match?(conn, %{route: route}) do
    route = String.trim_leading(route, "/")

    conn.path_info
    |> Enum.join("/")
    |> String.starts_with?(route)
  end

  defp menu_tabs(site) do
    for tab <- menu_items(site) do
      key = String.downcase(tab.title)

      route =
        tab
        |> Map.get(:children, [])
        |> List.first()
        |> Access.get(:route)

      tab
      |> Map.put_new(:children, [])
      |> Map.put_new(:route, route)
      |> Map.put_new(:key, key)
    end
  end

  # Public API

  def tab_class(tab, current_tab) do
    [
      "pebble-header-menu-item",
      tab.children == [] && "childless",
      tab == current_tab && "selected"
    ]
  end

  def child_class(child, current_page) do
    [
      "pebble-header-submenu-item",
      child == current_page && "selected"
    ]
  end

  def menu_items(site) do
    [
      %{title: "Dashboard", route: ~p"/#{site}"},
      %{title: "Records", children: [
        %{title: "Templates", route: ~p"/#{site}/templates"}
          | records_children(site)
      ]},
      %{title: "Design", children: [
        %{title: "Layouts", route: ~p"/#{site}/layouts"}
      ]},
      %{title: "Console", children: [
        %{title: "Endpoints", route: ~p"/#{site}/endpoints"},
        %{title: "Shell", route: ~p"/#{site}/shell"},
        %{title: "Logs", route: ~p"/#{site}/logs"}
      ]},
      %{title: "Settings", children: [
        %{title: "Identity", route: ~p"/#{site}/identity"},
        %{title: "Schemas", route: ~p"/#{site}/schemas"},
        %{title: "Preferences", route: ~p"/#{site}/preferences"}
      ]}
    ]
  end

  defp records_children(site) do
    for schema <- Pebble.fetch_schemas(site) do
      %{title: schema.label <> "s", route: ~p"/#{site}/s/#{schema}"}
    end
  end

  defp redirect_to_fallback(conn, [fallback | _]) do
    redirect(conn, to: ~p"/#{fallback}")
  end

  defp redirect_to_fallback(conn, []) do
    # If there are no sites, open the OOTB setup.
    redirect(conn, to: ~p"/")
  end
end
