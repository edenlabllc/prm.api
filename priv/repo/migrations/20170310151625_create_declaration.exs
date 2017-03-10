defmodule Prm.Repo.Migrations.CreatePrm.Declaration do
  use Ecto.Migration

  def change do
    create table(:declarations) do
      add :doctor_id, :string
      add :patient_id, :string
      add :msp_id, :string
      add :start_date, :utc_datetime
      add :end_date, :utc_datetime
      add :signature, :string
      add :certificate, :string
      add :status, :string
      add :signed_at, :utc_datetime
      add :created_by, :string
      add :updated_by, :string
      add :confident_person_id, :string
      add :is_active, :boolean, default: false, null: false

      timestamps()
    end

  end
end
