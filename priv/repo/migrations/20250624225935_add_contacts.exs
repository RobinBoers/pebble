defmodule Pebble.Repo.Migrations.AddContacts do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add :handle, :string
      add :url, :string
      add :email, :string
      add :notify, :boolean
    end
  end
end
