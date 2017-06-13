defmodule PRM.Web.EmployeeView do
  @moduledoc false

  use PRM.Web, :view
  alias PRM.Web.EmployeeView

  def render("index.json", %{employees: employees}) do
    render_many(employees, EmployeeView, "employee.json")
  end

  def render("show.json", %{employee: employee}) do
    render_one(employee, EmployeeView, "employee.json")
  end

  def render("employee.json", %{employee: %{employee_type: "doctor", doctor: doctor} = employee}) do
    employee
    |> render_employee()
    |> Map.put(:doctor, render_association(doctor))
  end

  def render("employee.json", %{employee: employee}) do
   render_employee(employee)
  end

  def render_employee(employee) do
   %{
      id: employee.id,
      position: employee.position,
      status: employee.status,
      employee_type: employee.employee_type,
      is_active: employee.is_active,
      inserted_by: employee.inserted_by,
      updated_by: employee.updated_by,
      start_date: employee.start_date,
      end_date: employee.end_date,
      party_id: employee.party_id,
      division_id: employee.division_id,
      legal_entity_id: employee.legal_entity_id,
      party: render_association(employee.party),
      division: render_association(employee.division),
      legal_entity: render_association(employee.legal_entity),
    }
  end

  def render_association(%Ecto.Association.NotLoaded{}), do: nil

  def render_association(%PRM.Parties.Party{} = party) do
    %{
      id: party.id,
      first_name: party.first_name,
      last_name: party.last_name,
      second_name: party.second_name,
    }
  end

  def render_association(%PRM.Entities.Division{} = division) do
    %{
      id: division.id,
      type: division.type,
      legal_entity_id: division.legal_entity_id,
      mountain_group: division.mountain_group,
    }
  end

  def render_association(%PRM.Entities.LegalEntity{} = legal_entity) do
    %{
      id: legal_entity.id,
      name: legal_entity.name,
      short_name: legal_entity.short_name,
      public_name: legal_entity.public_name,
      type: legal_entity.type,
      edrpou: legal_entity.edrpou,
      status: legal_entity.status,
      owner_property_type: legal_entity.owner_property_type,
      legal_form: legal_entity.legal_form,
    }
  end

  def render_association(association), do: association
end
