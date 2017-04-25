defmodule PRM.EmployeeRequests do
  @moduledoc false

  import Ecto.{Query, Changeset}, warn: false
  alias PRM.Repo

  alias PRM.EmployeeRequests.EmployeeRequest

  def create_employee_request(attrs \\ %{}), do: Repo.insert(%EmployeeRequest{data: attrs})
end
