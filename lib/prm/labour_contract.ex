defmodule Prm.LabourContract do
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

    belongs_to :doctor, Prm.Doctor
    belongs_to :msp, Prm.MSP

    timestamps(type: :utc_datetime)
  end
end
