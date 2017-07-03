defmodule PRM.Entities.LegalEntitySearch do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "legal_entity_search" do
    field :is_active, :boolean
    field :edrpou, :string
    field :type, :string
    field :owner_property_type, :string
    field :legal_form, :string
    field :status, :string
    embeds_one :address, Address do
      field :settlement_id, Ecto.UUID
    end
    field :created_by_mis_client_id, Ecto.UUID
  end
end
