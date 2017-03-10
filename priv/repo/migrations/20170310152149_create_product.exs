defmodule Prm.Repo.Migrations.CreatePrm.Product do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :parameters, :map

      timestamps()
    end

  end
end
