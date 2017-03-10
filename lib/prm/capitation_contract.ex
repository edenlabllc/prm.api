defmodule Prm.CapitationContract do
  use Ecto.Schema

  schema "capitation_contracts" do
    field :msp_id, :string
    field :product_id, :string
    field :start_date, :utc_datetime
    field :end_date, :utc_datetime
    field :status, :string
    field :signed_at, :utc_datetime
    field :services, {:array, :map}

    timestamps()
  end
end
