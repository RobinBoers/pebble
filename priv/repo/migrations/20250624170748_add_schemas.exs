defmodule Pebble.Repo.Migrations.AddSchemas do
  use Ecto.Migration

  def change do
    create table(:schemas) do
      add :label,      :string
      add :definition, :string

      timestamps()
    end
  end
end
