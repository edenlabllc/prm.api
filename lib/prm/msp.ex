defmodule Prm.MSP do
  use Ecto.Schema

  schema "msps" do
    field :name, :string
    field :short_name, :string
    field :type, :string
    field :edrpou, :string
    field :services, {:array, :map}
    field :licenses, :map
    field :accreditations, :map
    field :addresses, {:array, :map}
    field :phones, {:array, :map}
    field :emails, {:array, :map}
    field :created_by, :string
    field :updated_by, :string
    field :is_active, :boolean, default: false

    timestamps()
  end
end
