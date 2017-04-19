use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :prm, PRM.Web.Endpoint,
  http: [port: 4001],
  server: false

config :prm, sql_sandbox: true

config :logger, level: :debug
config :ex_unit, capture_log: true

# Configure your database
config :prm, PRM.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: System.get_env("MIX_TEST_DATABASE") || "prm_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
