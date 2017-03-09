defmodule PRM.Web.PageController do
  use PRM.Web, :controller
  alias PRM.Web.LaboursView

  def index(conn, _params) do
    conn
    |> put_status(200)
    |> render(LaboursView, "labour.json", %{id: 1})
  end
end
