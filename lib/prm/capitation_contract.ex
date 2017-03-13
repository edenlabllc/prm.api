defmodule Prm.CapitationContract do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "capitation_contracts" do
    field :start_date, :utc_datetime
    field :end_date, :utc_datetime
    field :status, :string
    field :signed_at, :utc_datetime
    field :services, {:array, :map}

    belongs_to :product, Prm.Product, type: Ecto.UUID
    belongs_to :msp, Prm.MSP, type: Ecto.UUID

    timestamps(type: :utc_datetime)
  end

  @fields ~W(
    start_date
    end_date
    status
    signed_at
    services
    product_id
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
    |> foreign_key_constraint(:product_id)
    |> foreign_key_constraint(:msp_id)
  end
end
