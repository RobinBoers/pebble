defmodule Pebble.Repo.Migrations.AddSites do
  use Ecto.Migration

  def change do
    create table(:sites) do
      add :hostname, :string
      add :vik_hostname,    :string
      add :scry_hostname,   :string

      timestamps()
    end
  end
end
