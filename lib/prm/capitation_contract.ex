defmodule Prm.CapitationContract do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "capitation_contracts" do
    field :msp_id, Ecto.UUID
    field :product_id, Ecto.UUID
    field :start_date, :utc_datetime
    field :end_date, :utc_datetime
    field :status, :string
    field :signed_at, :utc_datetime
    field :services, {:array, :map}

    timestamps()
  end
end
