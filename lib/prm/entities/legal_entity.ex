defmodule PRM.Entities.LegalEntity do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "legal_entities" do
    field :is_active, :boolean, default: false
    field :addresses, {:array, :map}
    field :edrpou, :string
    field :email, :string
    field :kveds, {:array, :string}
    field :legal_form, :string
    field :name, :string
    field :owner_property_type, :string
    field :phones, {:array, :map}
    field :public_name, :string
    field :short_name, :string
    field :status, :string
    field :type, :string
    field :inserted_by, Ecto.UUID
    field :updated_by, Ecto.UUID
    field :capitation_contract_id, :id

    timestamps()
  end
end
