defmodule Pebble.Repo.Migrations.AddAssets do
  use Ecto.Migration

  def change do
    create table(:assets, primary_key: false) do
      add :id, :string, primary_key: true
      add :url,      :text
      add :alt,      :text
      add :filename, :text

      timestamps()
    end
  end
end
