defmodule PRM.Web.MSPController do
  use PRM.Web, :controller

  alias PRM.Entities
  alias PRM.Entities.MSP

  action_fallback PRM.Web.FallbackController

  def index(conn, _params) do
    medical_service_providers = Entities.list_medical_service_providers()
    render(conn, "index.json", medical_service_providers: medical_service_providers)
  end

  def create(conn, %{"msp" => msp_params}) do
    with {:ok, %MSP{} = msp} <- Entities.create_msp(msp_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", msp_path(conn, :show, msp))
      |> render("show.json", msp: msp)
    end
  end

  def show(conn, %{"id" => id}) do
    msp = Entities.get_msp!(id)
    render(conn, "show.json", msp: msp)
  end

  def update(conn, %{"id" => id, "msp" => msp_params}) do
    msp = Entities.get_msp!(id)

    with {:ok, %MSP{} = msp} <- Entities.update_msp(msp, msp_params) do
      render(conn, "show.json", msp: msp)
    end
  end

  def delete(conn, %{"id" => id}) do
    msp = Entities.get_msp!(id)
    with {:ok, %MSP{}} <- Entities.delete_msp(msp) do
      send_resp(conn, :no_content, "")
    end
  end
end
