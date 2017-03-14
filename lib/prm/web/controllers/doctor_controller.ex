defmodule PRM.Web.DoctorController do
  use PRM.Web, :controller

  alias PRM.API
  alias PRM.API.Doctor

  action_fallback PRM.Web.FallbackController

  def index(conn, _params) do
    doctors = API.list_doctors()
    render(conn, "index.json", doctors: doctors)
  end

  def create(conn, %{"doctor" => doctor_params}) do
    with {:ok, %Doctor{} = doctor} <- API.create_doctor(doctor_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", doctor_path(conn, :show, doctor))
      |> render("show.json", doctor: doctor)
    end
  end

  def show(conn, %{"id" => id}) do
    doctor = API.get_doctor!(id)
    render(conn, "show.json", doctor: doctor)
  end

  def update(conn, %{"id" => id, "doctor" => doctor_params}) do
    doctor = API.get_doctor!(id)

    with {:ok, %Doctor{} = doctor} <- API.update_doctor(doctor, doctor_params) do
      render(conn, "show.json", doctor: doctor)
    end
  end

  def delete(conn, %{"id" => id}) do
    doctor = API.get_doctor!(id)
    with {:ok, %Doctor{}} <- API.delete_doctor(doctor) do
      send_resp(conn, :no_content, "")
    end
  end
end
