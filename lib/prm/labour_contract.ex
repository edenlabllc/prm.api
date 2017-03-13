defmodule Prm.LabourContract do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "labour_contracts" do
    field :doctor_id, Ecto.UUID
    field :msp_id, Ecto.UUID
    field :title, :string
    field :specialty, :string
    field :start_date, :utc_datetime
    field :end_date, :utc_datetime
    field :active, :boolean, default: false
    field :created_by, :string
    field :updated_by, :string

    timestamps(type: :utc_datetime)
  end
end
