use Mix.Config

# Web endpoint
config :ap_il, PRM.Web.Endpoint,
  http: [port: {:system, "APP_PORT"}],
  url: [
    host: {:system, "APP_HOST"},
    port: {:system, "APP_PORT"},
  ],
  secret_key_base: {:system, "APP_SECRET_KEY"},
  debug_errors: false,
  code_reloader: false

# Do not print debug messages in production
config :logger, level: :info

# Configure your database
config :prm, PRM.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "${DB_NAME}",
  username: "${DB_USER}",
  password: "${DB_PASSWORD}",
  hostname: "${DB_HOST}",
  port: "${DB_PORT}",
  pool_size: "${DB_POOL_SIZE}",
  timeout: 15_000,
  pool_timeout: 15_000
