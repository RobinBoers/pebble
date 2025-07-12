defmodule PebbleWeb.MenuController do
  @moduledoc false
  use PebbleWeb, :controller

  alias Pebble.Repo
  alias Pebble.Menu
  alias Pebble.Menu.Item
  alias Pebble.Menu.Category

  import Pebble,
    only: [
      get_menu_item: 2,
      get_menu_category: 2,
      fetch_menu_categories: 1
    ]

  import Ecto.Changeset

  def menu(conn, _params) do
    conn |> mount_menu_editor() |> render(:menu_editor)
  end

  def mount_menu_editor(conn) do
    mount_menu_editor(conn, Menu.changeset_for(conn.assigns.site))
  end

  def mount_menu_editor(conn, changeset) do
    item_changeset = Item.changeset_for(conn.assigns.site)
    category_changeset = Category.changeset_for(conn.assigns.site)

    conn
    |> assign(:changeset, changeset)
    |> assign(:menu, changeset.data)
    |> assign(:item_changeset, item_changeset)
    |> assign(:category_changeset, category_changeset)
  end

  def update(conn, %{"menu" => params}) do
    changeset = Menu.changeset_for(conn.assigns.site, params)

    case apply_menu_changes(changeset) do
      {:ok, _changeset} ->
        redirect(conn, to: ~p"/#{conn.assigns.site}/menu")

      {:error, changeset} ->
        conn |> mount_menu_editor(changeset) |> render(:menu_editor)
    end
  end

  def update(conn, _params) do
    redirect(conn, to: ~p"/#{conn.assigns.site}/menu")
  end

  defp apply_menu_changes(changeset)
       when not changeset.valid? do
    {:error, changeset}
  end

  defp apply_menu_changes(changeset) do
    Repo.transaction(fn ->
      apply_changes!(changeset, :items)
      apply_changes!(changeset, :categories)

      {:ok, changeset}
    end)
  end

  defp apply_changes!(changeset, key) do
    if changes = get_change(changeset, key) do
      for %{action: :update} = c <- changes, c.valid? do
        Repo.update!(c)
      end
    end
  end

  def new_item(conn, %{"item" => params}) do
    changeset = Item.changeset_for(conn.assigns.site, params)

    case Repo.insert(changeset) do
      {:ok, _item} ->
        redirect(conn, to: ~p"/#{conn.assigns.site}/menu")

      {:error, changeset} ->
        dbg(changeset)

        conn
        |> mount_menu_editor()
        |> assign(:item_changeset, changeset)
        |> render(:menu_editor)
    end
  end

  def item(conn, %{"id" => id}) do
    case get_menu_item(id, conn.assigns.site) do
      %Item{} = item ->
        categories =
          fetch_menu_categories(conn.assigns.site)

        conn
        |> assign(:item, item)
        |> assign(:categories, categories)
        |> assign(:changeset, Item.changeset(item))
        |> render(:item_editor)

      nil ->
        redirect(conn, to: ~p"/#{conn.assigns.site}/menu")
    end
  end

  def edit_item(conn, %{"id" => id, "item" => params}) do
    item = get_menu_item(id, conn.assigns.site)
    changeset = Item.changeset(item, params)

    case Repo.update(changeset) do
      {:ok, _item} ->
        send_resp(conn, 204, "")

      {:error, changeset} ->
        categories =
          fetch_menu_categories(conn.assigns.site)

        conn
        |> assign(:item, item)
        |> assign(:categories, categories)
        |> assign(:changeset, changeset)
        |> render(:item_editor)
    end
  end

  def delete_item(conn, %{"id" => id}) do
    item = get_menu_item(id, conn.assigns.site)

    case Repo.delete(item) do
      {:ok, _item} ->
        redirect(conn, to: ~p"/#{conn.assigns.site}/menu")

      {:error, changeset} ->
        categories =
          fetch_menu_categories(conn.assigns.site)

        conn
        |> assign(:item, item)
        |> assign(:categories, categories)
        |> assign(:changeset, changeset)
        |> render(:item_editor)
    end
  end

  def new_category(conn, %{"category" => params}) do
    changeset = Category.changeset_for(conn.assigns.site, params)

    case Repo.insert(changeset) do
      {:ok, _category} ->
        redirect(conn, to: ~p"/#{conn.assigns.site}/menu")

      {:error, changeset} ->        
        conn
        |> mount_menu_editor()
        |> assign(:category_changeset, changeset)
        |> render(:menu_editor)
    end
  end

  def category(conn, %{"id" => id}) do
    case get_menu_category(id, conn.assigns.site) do
      %Category{} = category ->
        conn
        |> assign(:category, category)
        |> assign(:changeset, Category.changeset(category))
        |> render(:category_editor)

      nil ->
        redirect(conn, to: ~p"/#{conn.assigns.site}/menu")
    end
  end

  def edit_category(conn, %{"id" => id, "category" => params}) do
    category = get_menu_category(id, conn.assigns.site)
    changeset = Category.changeset(category, params)

    case Repo.update(changeset) do
      {:ok, _category} ->
        send_resp(conn, 204, "")

      {:error, changeset} ->
        conn
        |> assign(:category, category)
        |> assign(:changeset, changeset)
        |> render(:category_editor)
    end
  end

  def delete_category(conn, %{"id" => id}) do
    category = get_menu_category(id, conn.assigns.site)

    case Repo.delete(category) do
      {:ok, _category} ->
        redirect(conn, to: ~p"/#{conn.assigns.site}/menu")

      {:error, changeset} ->
        conn
        |> assign(:category, category)
        |> assign(:changeset, changeset)
        |> render(:category_editor)
    end
  end
end
