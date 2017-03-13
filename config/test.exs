use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :prm, PRM.Web.Endpoint,
  http: [port: 4001],
  server: false

# DBs
config :prm, PRM.Repo,
  pool: Ecto.Adapters.SQL.Sandbox,
  database: System.get_env("MIX_TEST_DATABASE") || "prm_test"

# Run acceptance test in concurrent mode
config :prm,
  sql_sandbox: true

# Print only warnings and errors during test
config :logger, level: :info
config :ex_unit, capture_log: true