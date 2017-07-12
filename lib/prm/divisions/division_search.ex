defmodule PRM.Divisions.DivisionSearch do
  @moduledoc false

  use Ecto.Schema

  schema "division_search" do
    field :name, :string
    field :type, :string
    field :legal_entity_id, Ecto.UUID
  end
end
