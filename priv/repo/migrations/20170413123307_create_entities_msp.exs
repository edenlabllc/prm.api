defmodule PRM.Repo.Migrations.CreatePRM.Entities.MSP do
  use Ecto.Migration

  def change do
    create table(:medical_service_providers, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :accreditation, :map
      add :license, :map

      timestamps()
    end
  end
end
