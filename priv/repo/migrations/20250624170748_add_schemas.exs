defmodule Pebble.Repo.Migrations.AddSchemas do
  use Ecto.Migration

  def change do
    create table(:schemas) do
      add :label,      :text
      add :definition, :text

      timestamps()
    end
  end
end
