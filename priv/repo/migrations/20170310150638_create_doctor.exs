defmodule Prm.Repo.Migrations.CreatePrm.Doctor do
  use Ecto.Migration

  def change do
    create table(:doctors, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :mpi_id, :string
      add :status, :string
      add :education, {:array, :map}
      add :certificates, {:array, :map}
      add :licenses, {:array, :map}
      add :jobs, {:array, :map}
      add :is_active, :boolean, default: false, null: false
      add :name, :string
      add :created_by, :string
      add :updated_by, :string

      timestamps(type: :utc_datetime)
    end

  end
end
