defmodule PRM.Declaration do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias PRM.Repo

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

    belongs_to :doctor, PRM.Doctor, type: Ecto.UUID
    belongs_to :msp, PRM.MSP, type: Ecto.UUID

    timestamps(type: :utc_datetime)
  end
end
