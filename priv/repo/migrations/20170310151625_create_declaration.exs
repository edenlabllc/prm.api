defmodule Prm.Repo.Migrations.CreatePrm.Declaration do
  use Ecto.Migration

  def change do
    create table(:declarations, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :doctor_id, references(:doctors), null: false
      add :patient_id, :uuid
      add :msp_id, references(:msps), null: false
      add :start_date, :utc_datetime
      add :end_date, :utc_datetime
      add :signature, :string
      add :certificate, :string
      add :status, :string
      add :signed_at, :utc_datetime
      add :created_by, :string
      add :updated_by, :string
      add :confident_person_id, :uuid
      add :active, :boolean, default: false, null: false

      timestamps(type: :utc_datetime)
    end
  end
end
