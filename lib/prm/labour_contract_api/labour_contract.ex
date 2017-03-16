defmodule PRM.LabourContract do
  @moduledoc false
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "labour_contracts" do
    field :title, :string
    field :specialty, :string
    field :start_date, :utc_datetime
    field :end_date, :utc_datetime
    field :active, :boolean, default: false
    field :created_by, :string
    field :updated_by, :string

    belongs_to :doctor, PRM.Doctor, type: Ecto.UUID
    belongs_to :msp, PRM.MSP, type: Ecto.UUID

    timestamps(type: :utc_datetime)
  end
end
