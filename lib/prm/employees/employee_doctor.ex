defmodule PRM.Employees.EmployeeDoctor do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  @derive {Poison.Encoder, except: [:__meta__, :employee, :employee_id, :inserted_at, :updated_at]}

  schema "employee_doctors" do
    field :science_degree, :map
    field :qualifications, {:array, :map}
    field :educations, {:array, :map}
    field :specialities, {:array, :map}

    belongs_to :employee, PRM.Employees.Employee, type: Ecto.UUID

    timestamps()
  end

  def changeset(%PRM.Employees.EmployeeDoctor{} = employee_doctor, attrs) do
    employee_doctor
    |> cast(attrs, ~w(science_degree qualifications educations specialities)a)
    |> validate_required(~w(educations specialities)a)
  end

  def embed_changeset(schema, attrs), do: cast(schema, attrs, Map.keys(attrs))
end
