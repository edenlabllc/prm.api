defmodule PRM.Repo.Migrations.CreatePRM.Entities.Division do
  use Ecto.Migration

  def change do
    create table(:divisions, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :external_id, :string
      add :name, :string
      add :type, :string
      add :mountain_group, :string
      add :address, :map
      add :phones, :map
      add :email, :string

      timestamps()
    end
  end
end
