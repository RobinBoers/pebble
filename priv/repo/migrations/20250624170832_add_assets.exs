defmodule Pebble.Repo.Migrations.AddAssets do
  use Ecto.Migration

  def change do
    create table(:assets) do
      add :url,      :string
      add :alt,      :string
      add :filename, :string

      timestamps()
    end
  end
end
