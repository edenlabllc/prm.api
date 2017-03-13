defmodule Prm.MSP do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "msps" do
    field :name, :string
    field :short_name, :string
    field :type, :string
    field :edrpou, :string
    field :services, {:array, :map}
    field :licenses, {:array, :map}
    field :accreditations, {:array, :map}
    field :addresses, {:array, :map}
    field :phones, {:array, :map}
    field :emails, {:array, :map}
    field :created_by, :string
    field :updated_by, :string
    field :active, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @fields ~W(
    name
    short_name
    type
    edrpou
    services
    licenses
    accreditations
    addresses
    phones
    emails
    created_by
    updated_by
    active
  )

  def insert(params) do
    %__MODULE__{}
    |> changeset(params)
    |> PRM.Repo.insert
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
  end
end
