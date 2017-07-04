defmodule PRM.Employees.EmployeeSearch do
  @moduledoc false

  use Ecto.Schema

  schema "employee_search" do
    field :party_id, Ecto.UUID
    field :division_id, Ecto.UUID
    field :legal_entity_id, Ecto.UUID
    embeds_one :party, Party do
      field :tax_id, :string
    end
    embeds_one :legal_entity, LegalEntity do
      field :edrpou, :string
    end
    field :employee_type, :string
    field :status, :string
    field :starting_after, :string
    field :ending_before, :string
    field :is_active, :boolean
    field :limit, :integer
  end
end
