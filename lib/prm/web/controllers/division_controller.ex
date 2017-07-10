defmodule PRM.Web.DivisionController do
  @moduledoc false

  use PRM.Web, :controller

  alias PRM.Divisions
  alias PRM.Divisions.Division

  action_fallback PRM.Web.FallbackController

  def index(conn, params) do
    with {divisions, %Ecto.Paging{} = paging} <- Divisions.list_divisions(params) do
      render(conn, "index.json", divisions: divisions, paging: paging)
    end
  end

  def create(conn, division_params) do
    with {:ok, %Division{} = division} <- Divisions.create_division(division_params, get_consumer_id(conn)) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", division_path(conn, :show, division))
      |> render("show.json", division: division)
    end
  end

  def show(conn, %{"id" => id}) do
    division = Divisions.get_division!(id)
    render(conn, "show.json", division: division)
  end

  def update(conn, %{"id" => id} = division_params) do
    division = Divisions.get_division!(id)

    with {:ok, %Division{} = division} <- Divisions.update_division(division, division_params, get_consumer_id(conn)) do
      render(conn, "show.json", division: division)
    end
  end

  def set_mountain_group(conn, params) do
    with {_, nil} <- Divisions.set_divisions_mountain_group(params) do
      render(conn, "index.json", divisions: [])
    end
  end
end
