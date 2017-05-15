defmodule PRM.Web.GlobalParameterController do
  @moduledoc false

  use PRM.Web, :controller

  alias Plug.Conn
  alias PRM.GlobalParameters

  action_fallback PRM.Web.FallbackController

  def index(conn, _params) do
    with global_parameters <- GlobalParameters.list_global_parameters() do
      render(conn, "index.json", global_parameters: global_parameters)
    end
  end

  def create_or_update(conn, params) do
    x_consumer_id =
      conn
      |> Conn.get_req_header("x-consumer-id")
      |> Enum.at(0)

    with {:ok, global_parameters} <- GlobalParameters.create_or_update_global_parameters(params, x_consumer_id) do
      render(conn, "index.json", global_parameters: global_parameters)
    end
  end
end
