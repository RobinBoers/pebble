defmodule Pebble.Repo.Migrations.AddAssets do
  use Ecto.Migration

  def change do
    create table(:assets) do
      add :url,      :text
      add :alt,      :text
      add :filename, :text

      timestamps()
    end
  end
end
