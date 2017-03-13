defmodule Prm.LabourContract do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "labour_contracts" do
    field :title, :string
    field :specialty, :string
    field :start_date, :utc_datetime
    field :end_date, :utc_datetime
    field :active, :boolean, default: false
    field :created_by, :string
    field :updated_by, :string

    belongs_to :doctor, Prm.Doctor, type: Ecto.UUID
    belongs_to :msp, Prm.MSP, type: Ecto.UUID

    timestamps(type: :utc_datetime)
  end

  @fields ~W(
    title
    specialty
    start_date
    end_date
    active
    created_by
    updated_by
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
