defmodule Prm.Declaration do
  use Ecto.Schema

  schema "declarations" do
    field :doctor_id, :string
    field :patient_id, :string
    field :msp_id, :string
    field :start_date, :utc_datetime
    field :end_date, :utc_datetime
    field :signature, :string
    field :certificate, :string
    field :status, :string
    field :signed_at, :utc_datetime
    field :created_by, :string
    field :updated_by, :string
    field :confident_person_id, :string
    field :is_active, :boolean, default: false

    timestamps()
  end
end
