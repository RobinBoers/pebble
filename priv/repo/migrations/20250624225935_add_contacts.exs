defmodule Pebble.Repo.Migrations.AddContacts do
  use Ecto.Migration

  def change do
    create table(:contacts, primary_key: false) do
      add :id, :string, primary_key: true
      add :handle, :text
      add :url,    :text
      add :email,  :text
      add :notify, :boolean
    end

    create unique_index(:contacts, [:handle])
  end
end
