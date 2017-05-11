defmodule PRM.Web.GlobalParameterController do
  @moduledoc false

  use PRM.Web, :controller

  alias PRM.GlobalParameters

  action_fallback PRM.Web.FallbackController

  def index(conn, _params) do
    with global_parameters <- GlobalParameters.list_global_parameters() do
      render(conn, "index.json", global_parameters: global_parameters)
    end
  end
end
