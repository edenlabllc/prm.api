defmodule Prm.LabourContract do
  use Ecto.Schema

  schema "labour_contracts" do
    field :id, :string
    field :doctor_id, :string
    field :msp_id, :string
    field :title, :string
    field :specialty, :string
    field :start_date, :utc_datetime
    field :end_date, :utc_datetime
    field :is_active, :boolean, default: false
    field :created_by, :string
    field :updated_by, :string

    timestamps()
  end
end
