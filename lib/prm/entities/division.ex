defmodule PRM.Entities.Division do
  use Ecto.Schema

  schema "divisions" do
    field :address, :map
    field :email, :string
    field :external_id, :string
    field :mountain_group, :string
    field :name, :string
    field :phones, :map
    field :type, :string
    field :legal_entity_id, :id

    timestamps()
  end
end
