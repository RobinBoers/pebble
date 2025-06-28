defmodule PebbleWeb.Navigation do
  @moduledoc false
  use PebbleWeb, :live_hook

  alias Pebble.Site

  def on_mount(_, %{"site" => hostname}, _session, socket) do
    sites = Pebble.fetch_sites()

    case Enum.find(sites, &(&1.hostname == hostname)) do
      %Site{} = site -> mount_site(socket, sites, site)
      nil -> redirect_to_fallback(socket, sites)
    end
  end

  def on_mount(_, _params, _session, socket) do
    redirect_to_fallback(socket, Pebble.fetch_sites())
  end

  defp mount_site(socket, sites, site) do
    {:cont, socket
     |> assign(:site, site)
     |> assign(:sites, sites)
     |> assign_menu()
     |> attach_hook(:url, :handle_params, &handle_params/3)
     |> attach_hook(:choose, :handle_event, &handle_event/3)}
  end

  defp assign_menu(socket) do
    site = socket.assigns.site

    assign(socket, :menu_items, [
      %{view: PebbleWeb.DashboardLive, title: "Dashboard", route: ~p"/#{site}", icon: "hero-home"},
      %{view: PebbleWeb.FragmentsLive, title: "Fragments", route: ~p"/#{site}/fragments", icon: "hero-square-3-stack-3d"},
      %{view: PebbleWeb.TemplatesLive, title: "Templates", route: ~p"/#{site}/templates", icon: "hero-code-bracket"},
      %{view: PebbleWeb.EndpointsLive, title: "Endpoints", route: ~p"/#{site}/endpoints", icon: "hero-cloud"},
      %{view: PebbleWeb.ShellLive, title: "Console", route: ~p"/#{site}/console/shell", icon: "hero-command-line"},
      %{view: PebbleWeb.LayoutsLive, title: "Layouts", route: ~p"/#{site}/layouts", icon: "hero-swatch"},
      %{view: PebbleWeb.MediaLive, title: "Media", route: ~p"/#{site}/media", icon: "hero-photo"},
      %{view: PebbleWeb.ContactsLive, title: "Contacts", route: ~p"/#{site}/contacts", icon: "hero-at-symbol"},
      %{view: PebbleWeb.MenuLive, title: "Menu", route: ~p"/#{site}/menu", icon: "hero-cursor-arrow-rays"},
      %{view: PebbleWeb.StatisticsLive, title: "Statistics", route: ~p"/#{site}/stats", icon: "hero-chart-bar"},
      %{view: PebbleWeb.SettingsLive, title: "Settings", route: ~p"/#{site}/settings", icon: "hero-cog-6-tooth"},
      %{view: PebbleWeb.SchemasLive, title: "Schemas", route: ~p"/#{site}/schemas", icon: "hero-puzzle-piece"}
    ])
  end

  defp redirect_to_fallback(socket, [fallback | _]) do
    {:halt, push_navigate(socket, to: ~p"/#{fallback}")}
  end

  defp redirect_to_fallback(_socket, []) do
    raise "no sites available :("
  end

  def handle_params(_params, url, socket) do
    {:cont, assign(socket, :url, url)}
  end

  def handle_event("choose-site", %{"site" => hostname}, socket) do
    {:halt, push_navigate(socket, to: replace_site(socket, hostname))}
  end

  def handle_event(_event, _params, socket) do
    {:cont, socket}
  end

  defp replace_site(socket, hostname) do
    %URI{path: path} = URI.parse(socket.assigns.url)
    case String.split(path, "/", trim: true) do
      [] -> "/" <> hostname
      [_ | rest] -> "/" <> Enum.join([hostname | rest], "/")
    end
  end
end
