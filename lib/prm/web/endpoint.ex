defmodule PRM.Web.Endpoint do
  @moduledoc """
  Module with API response plugins
  """
  use Phoenix.Endpoint, otp_app: :prm

  # Allow acceptance tests to run in concurrent mode
  if Application.get_env(:prm, :sql_sandbox) do
    plug Phoenix.Ecto.SQL.Sandbox
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug EView

  plug Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug PRM.Web.Router

end
