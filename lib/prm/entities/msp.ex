defmodule PRM.Entities.MSP do
  use Ecto.Schema

  schema "medical_service_providers" do
    field :accreditation, :map
    field :license, :map
    field :legal_entity_id, :id

    timestamps()
  end
end
