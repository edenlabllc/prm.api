defmodule Prm.Doctor do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "doctors" do
    field :mpi_id, :string
    field :status, :string
    field :education, {:array, :map}
    field :certificates, {:array, :map}
    field :licenses, {:array, :map}
    field :jobs, {:array, :map}
    field :is_active, :boolean, default: false
    field :name, :string
    field :created_by, :string
    field :updated_by, :string

    timestamps(type: :utc_datetime)
  end
end
