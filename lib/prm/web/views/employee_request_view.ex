defmodule PRM.Web.EmployeeRequestView do
  @moduledoc false

  use PRM.Web, :view
  alias PRM.Web.EmployeeRequestView

  def render("show.json", %{employee_request: employee_request}), do: employee_request
end
