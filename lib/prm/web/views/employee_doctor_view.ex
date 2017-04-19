defmodule PRM.Web.EmployeeDoctorView do
  use PRM.Web, :view
  alias PRM.Web.EmployeeDoctorView

  def render("index.json", %{employee_doctors: employee_doctors}) do
    render_many(employee_doctors, EmployeeDoctorView, "employee_doctor.json")
  end

  def render("show.json", %{employee_doctor: employee_doctor}) do
    render_one(employee_doctor, EmployeeDoctorView, "employee_doctor.json")
  end

  def render("employee_doctor.json", %{employee_doctor: employee_doctor}) do
    %{id: employee_doctor.id,
      education: employee_doctor.education,
      qualification: employee_doctor.qualification,
      specialities: employee_doctor.specialities,
      science_degree: employee_doctor.science_degree}
  end
end
