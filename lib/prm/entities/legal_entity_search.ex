defmodule PRM.Entities.LegalEntitySearch do
  @moduledoc false

  use Ecto.Schema

  schema "legal_entity_search" do
    field :is_active, :boolean
    field :edrpou, :string
    field :type, :string
    field :owner_property, :string
    field :status, :string
  end
end
