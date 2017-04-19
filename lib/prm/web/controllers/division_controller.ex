defmodule PRM.Web.DivisionController do
  @moduledoc false

  use PRM.Web, :controller

  alias PRM.Entities
  alias PRM.Entities.Division

  action_fallback PRM.Web.FallbackController

  def index(conn, params) do
    with {divisions, %Ecto.Paging{} = paging} <- Entities.list_divisions(params) do
      render(conn, "index.json", divisions: divisions, paging: paging)
    end
  end

  def create(conn, division_params) do
    with {:ok, %Division{} = division} <- Entities.create_division(division_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", division_path(conn, :show, division))
      |> render("show.json", division: division)
    end
  end

  def show(conn, %{"id" => id}) do
    division = Entities.get_division!(id)
    render(conn, "show.json", division: division)
  end

  def update(conn, %{"id" => id} = division_params) do
    division = Entities.get_division!(id)

    with {:ok, %Division{} = division} <- Entities.update_division(division, division_params) do
      render(conn, "show.json", division: division)
    end
  end
end
