defmodule PRM.Doctor do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "doctors" do
    field :mpi_id, :string
    field :status, :string
    field :education, {:array, :map}
    field :certificates, {:array, :map}
    field :licenses, {:array, :map}
    field :jobs, {:array, :map}
    field :active, :boolean, default: false
    field :name, :string
    field :created_by, :string
    field :updated_by, :string

    timestamps(type: :utc_datetime)
  end

  @fields ~W(
    mpi_id
    status
    education
    certificates
    licenses
    jobs
    active
    name
    created_by
    updated_by
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
