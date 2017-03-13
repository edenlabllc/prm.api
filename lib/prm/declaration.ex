defmodule Prm.Declaration do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

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

    belongs_to :doctor, Prm.Doctor, type: Ecto.UUID
    belongs_to :msp, Prm.MSP, type: Ecto.UUID

    timestamps(type: :utc_datetime)
  end

  @fields ~W(
    patient_id
    start_date
    end_date
    signature
    certificate
    status
    signed_at
    created_by
    updated_by
    confident_person_id
    active
    doctor_id
    msp_id
  )

  def insert(params) do
    %__MODULE__{}
    |> changeset(params)
    |> PRM.Repo.insert
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
    |> foreign_key_constraint(:doctor_id)
    |> foreign_key_constraint(:msp_id)
  end
end
