defmodule Prm.Declaration do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "declarations" do
    field :patient_id, Ecto.UUID
    field :start_date, :utc_datetime
    field :end_date, :utc_datetime
    field :signature, :string
    field :certificate, :string
    field :status, :string
    field :signed_at, :utc_datetime
    field :created_by, :string
    field :updated_by, :string
    field :confident_person_id, Ecto.UUID
    field :active, :boolean, default: false

    belongs_to :doctor, Prm.Doctor
    belongs_to :msp, Prm.MSP

    timestamps(type: :utc_datetime)
  end
end
