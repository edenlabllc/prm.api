defmodule PRM.Entities.LegalEntitySearch do
  @moduledoc false

  use Ecto.Schema

  schema "legal_entity_search" do
    field :is_active, :boolean
    field :edrpou, :string
    field :type, :string
    field :legal_form, :string
    field :owner_property_type, :string
    field :status, :string
    field :created_by_mis_client_id, Ecto.UUID
  end
end
