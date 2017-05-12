defmodule PRM.Employees.Employee do
  @moduledoc false

  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "employees" do
    field :employee_type, :string
    field :end_date, :naive_datetime
    field :is_active, :boolean, default: false
    field :position, :string
    field :start_date, :naive_datetime
    field :status, :string
    field :status_reason, :string
    field :updated_by, Ecto.UUID
    field :inserted_by, Ecto.UUID

    belongs_to :party, PRM.Parties.Party, type: Ecto.UUID
    belongs_to :division, PRM.Entities.Division, type: Ecto.UUID
    belongs_to :legal_entity, PRM.Entities.LegalEntity, type: Ecto.UUID

    has_one :doctor, PRM.Employees.EmployeeDoctor

    timestamps()
  end
end
