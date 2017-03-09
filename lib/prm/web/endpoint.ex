defmodule PRM.Web.Endpoint do
  @moduledoc """
  Module with API response plugins
  """
  use Phoenix.Endpoint, otp_app: :prm

#  socket "/socket", PRM.Web.UserSocket


  # Allow acceptance tests to run in concurrent mode
  if Application.get_env(:prm, :sql_sandbox) do
    plug Phoenix.Ecto.SQL.Sandbox
  end

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug EView
  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison,
    length: 4_294_967_296,
    read_length: 2_000_000,
    read_timeout: 108_000

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_prm_api_key",
    signing_salt: "/IqLUirg"

  plug PRM.Web.Router

  @doc """
  Dynamically loads configuration from the system environment
  on startup.

  It receives the endpoint configuration from the config files
  and must return the updated configuration.
  """
  def load_from_system_env(config) do
    port = System.get_env("PORT") || raise "expected the PORT environment variable to be set"
    {:ok, Keyword.put(config, :http, [:inet6, port: port])}
  end
end
