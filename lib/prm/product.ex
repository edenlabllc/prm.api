defmodule Prm.Product do
  use Ecto.Schema

  schema "products" do
    field :name, :string
    field :parameters, :map

    timestamps(type: :utc_datetime)
  end

  @fields ~W(
    name
    parameters
  )

  def insert(params) do
    %__MODULE__{}
    |> changeset(params)
    |> PRM.Repo.insert
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @fields)
  end
end
