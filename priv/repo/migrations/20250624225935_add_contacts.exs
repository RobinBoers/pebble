defmodule Pebble.Repo.Migrations.AddContacts do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add :handle, :text
      add :url,    :text
      add :email,  :text
      add :notify, :boolean
    end

    create unique_index(:contacts, [:handle])
  end
end
