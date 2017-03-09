defmodule PRM.Web.Endpoint do
  @moduledoc """
  Module with API response plugins
  """
  use Phoenix.Endpoint, otp_app: :prm

  # Allow acceptance tests to run in concurrent mode
  if Application.get_env(:prm, :sql_sandbox) do
    plug Phoenix.Ecto.SQL.Sandbox
  end

  plug EView
  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison,
    length: 33_554_432,
    read_length: 2_000_000,
    read_timeout: 108_000

  plug Plug.MethodOverride
  plug Plug.Head
  plug PRM.Web.Router

end
