defmodule PRM.Entities.DivisionSearch do
  @moduledoc false

  use Ecto.Schema

  schema "division_search" do
    field :type, :string
    field :legal_entity_id, Ecto.UUID
  end
end
