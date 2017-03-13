defmodule Prm.Repo.Migrations.CreatePrm.LabourContract do
  use Ecto.Migration

  def change do
    create table(:labour_contracts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :doctor_id, :string
      add :msp_id, :string
      add :title, :string
      add :specialty, :string
      add :start_date, :utc_datetime
      add :end_date, :utc_datetime
      add :is_active, :boolean, default: false, null: false
      add :created_by, :string
      add :updated_by, :string

      timestamps()
    end

  end
end
