defmodule PRM.Repo.Migrations.CreatePRM.Product do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :parameters, :map

      timestamps(type: :utc_datetime)
    end
  end
end
