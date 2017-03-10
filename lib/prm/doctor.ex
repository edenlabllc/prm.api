defmodule Prm.Doctor do
  use Ecto.Schema

  schema "doctors" do
    field :add_doctor_table, :string
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

    timestamps()
  end
end
