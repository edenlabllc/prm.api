defmodule Prm.Repo.Migrations.CreatePrm.Doctor do
  use Ecto.Migration

  def change do
    create table(:doctors) do
      add :add_doctor_table, :string
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

      timestamps()
    end

  end
end
