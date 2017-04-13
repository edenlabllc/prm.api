defmodule PRM.Repo.Migrations.CreatePRM.Entities.MSP do
  use Ecto.Migration

  def change do
    create table(:medical_service_providers) do
      add :accreditation, :map
      add :license, :map

      timestamps()
    end
  end
end
