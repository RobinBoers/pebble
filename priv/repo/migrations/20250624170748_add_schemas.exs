defmodule Pebble.Repo.Migrations.AddSchemas do
  use Ecto.Migration

  def change do
    create table(:schemas, primary_key: false) do
      add :id, :string, primary_key: true
      add :label,      :text
      add :definition, :text

      timestamps()
    end
  end
end
