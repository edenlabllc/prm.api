defmodule PRM.Entities.LegalEntity do
  use Ecto.Schema

  schema "legal_entities" do
    field :active, :boolean, default: false
    field :addresses, :map
    field :created_by, :string
    field :edrpou, :integer
    field :email, :string
    field :kveds, :map
    field :legal_form, :string
    field :name, :string
    field :owner_property_type, :string
    field :phones, :map
    field :public_name, :string
    field :short_name, :string
    field :status, :string
    field :type, :string
    field :updated_by, :string
    field :msp_id, :id
    field :capitation_contract_id, :id

    timestamps()
  end
end
