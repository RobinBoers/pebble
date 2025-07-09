defmodule PebbleWeb.ContactsController do
  @moduledoc false
  use PebbleWeb, :controller

  alias Pebble.Repo
  alias Pebble.Contact

  import Pebble, only: [
    fetch_contacts: 0,
    get_contact: 1
  ]

  def contacts(conn, _params) do
    conn
    |> mount_contacts()
    |> assign(:changeset, Contact.changeset())
    |> render(:listing)
  end

  defp mount_contacts(conn) do
    assign(conn, :contacts, fetch_contacts())
  end

  def new(conn, %{"contact" => params}) do
    changeset = Contact.changeset(%Contact{}, params)

    case Repo.insert(changeset) do
      {:ok, contact} ->
        redirect(conn, to: ~p"/#{conn.assigns.site}/contacts/#{contact}")

      {:error, changeset} ->
        conn |> mount_contacts() |> render(:listing, changeset: changeset)
    end
  end

  def contact(conn, %{"id" => id}) do
    case get_contact(id) do
      %Contact{} = contact ->
        conn
        |> mount_contacts()
        |> assign(:contact, contact)
        |> assign(:changeset, Contact.changeset(contact))
        |> render(:editor)

      nil ->
        redirect(conn, to: ~p"/#{conn.assigns.site}/contacts")
    end
  end

  def edit(conn, %{"id" => id, "contact" => params}) do
    contact = Pebble.get_contact(id)
    changeset = Contact.changeset(contact, params)

    case Repo.update(changeset) do
      {:ok, _contact} ->
        send_resp(conn, 204, "")

      {:error, changeset} ->
        conn
        |> mount_contacts()
        |> assign(:contact, contact)
        |> assign(:changeset, changeset)
        |> render(:editor)
    end
  end

  def delete(conn, %{"id" => id}) do
    contact = Pebble.get_contact(id)

    case Repo.delete(contact) do
      {:ok, _contact} ->
        redirect(conn, to: ~p"/#{conn.assigns.site}/contacts")

      {:error, changeset} ->
        conn
        |> mount_contacts()
        |> assign(:contact, contact)
        |> assign(:changeset, changeset)
        |> render(:editor)
    end
  end
end