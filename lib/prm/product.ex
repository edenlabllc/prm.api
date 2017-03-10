defmodule Prm.Product do
  use Ecto.Schema

  schema "products" do
    field :name, :string
    field :parameters, :map

    timestamps()
  end
end
