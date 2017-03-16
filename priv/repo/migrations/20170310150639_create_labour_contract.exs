defmodule PRM.Repo.Migrations.CreatePrm.LabourContract do
  use Ecto.Migration

  def change do
    create table(:labour_contracts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :doctor_id, references(:doctors, type: :uuid), null: false
      add :msp_id, references(:msps, type: :uuid), null: false
      add :title, :string
      add :specialty, :string
      add :start_date, :utc_datetime
      add :end_date, :utc_datetime
      add :active, :boolean, default: false, null: false
      add :created_by, :string
      add :updated_by, :string

      timestamps(type: :utc_datetime)
    end
  end
end
