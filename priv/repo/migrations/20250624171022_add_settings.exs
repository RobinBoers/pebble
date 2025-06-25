defmodule Pebble.Repo.Migrations.AddSettings do
  use Ecto.Migration

  def change do
    create table(:settings) do
      add :data,       :text
      add :defintion,  :text

      add :site_id, references(:sites, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:settings, [:site_id])
  end
end
