defmodule PRM.Web.MSPController do
  @moduledoc false

  use PRM.Web, :controller

  alias PRM.MSPAPI
  alias PRM.MSP

  action_fallback PRM.Web.FallbackController

  def index(conn, _params) do
    msps = MSPAPI.list_msps()
    render(conn, "index.json", msps: msps)
  end

  def create(conn, %{"msp" => msp_params}) do
    with {:ok, %MSP{} = msp} <- MSPAPI.create_msp(msp_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", msp_path(conn, :show, msp))
      |> render("show.json", msp: msp)
    end
  end

  def show(conn, %{"id" => id}) do
    msp = MSPAPI.get_msp!(id)
    render(conn, "show.json", msp: msp)
  end

  def update(conn, %{"id" => id, "msp" => msp_params}) do
    msp = MSPAPI.get_msp!(id)
    with {:ok, %MSP{} = msp} <- MSPAPI.update_msp(msp, msp_params) do
      render(conn, "show.json", msp: msp)
    end
  end

  def delete(conn, %{"id" => id}) do
    msp = MSPAPI.get_msp!(id)
    with {:ok, %MSP{}} <- MSPAPI.delete_msp(msp) do
      send_resp(conn, :no_content, "")
    end
  end
end
