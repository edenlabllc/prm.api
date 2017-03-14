defmodule PRM.Web.DoctorView do
  use PRM.Web, :view

  alias PRM.Web.DoctorView

  def render("index.json", %{doctors: doctors}) do
    render_many(doctors, DoctorView, "doctor.json")
  end

  def render("show.json", %{doctor: doctor}) do
    render_one(doctor, DoctorView, "doctor.json")
  end

  def render("doctor.json", %{doctor: doctor}) do
    %{
      id:           doctor.id,
      mpi_id:       doctor.mpi_id,
      status:       doctor.status,
      education:    doctor.education,
      certificates: doctor.certificates,
      licenses:     doctor.licenses,
      jobs:         doctor.jobs,
      active:       doctor.active,
      name:         doctor.name,
      created_by:   doctor.created_by,
      updated_by:   doctor.updated_by
    }
  end
end
