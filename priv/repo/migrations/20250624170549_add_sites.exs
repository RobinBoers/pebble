defmodule Pebble.Repo.Migrations.AddSites do
  use Ecto.Migration

  def change do
    create table(:sites, primary_key: false) do
      add :id, :string, primary_key: true
      add :hostname,        :text
      add :vik_hostname,    :text
      add :scry_hostname,   :text

      timestamps()
    end

    create unique_index(:sites, [:hostname])
  end
end
