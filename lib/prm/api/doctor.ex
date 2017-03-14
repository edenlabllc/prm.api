defmodule Prm.API.Doctor do
  use Ecto.Schema

  schema "api_doctors" do
    field :thing, :string

    timestamps()
  end
end
