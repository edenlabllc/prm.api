defmodule Prm.Web.DoctorView do
  use Prm.Web, :view
  alias Prm.Web.DoctorView

  def render("index.json", %{doctors: doctors}) do
    %{data: render_many(doctors, DoctorView, "doctor.json")}
  end

  def render("show.json", %{doctor: doctor}) do
    %{data: render_one(doctor, DoctorView, "doctor.json")}
  end

  def render("doctor.json", %{doctor: doctor}) do
    %{id: doctor.id,
      thing: doctor.thing}
  end
end
