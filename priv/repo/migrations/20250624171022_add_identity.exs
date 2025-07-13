defmodule Pebble.Repo.Migrations.AddIdentity do
  use Ecto.Migration

  def change do
    create table(:identity, primary_key: false) do
      add :id, :string, primary_key: true
      add :data,        :text
      add :definition,  :text

      add :site_id, references(:sites, type: :string, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:identity, [:site_id])
  end
end
