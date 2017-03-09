use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).
config :prm, PRM.Web.Endpoint,
  secret_key_base: "0R/gw3HSB+GPZNpcsNIroCNy9h1XshUX4fTn8iE7uCVbglVbhBkigSl6WkMLQpNA"

# Configure your database
config :prm, PRM.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "prm_api_prod",
  pool_size: 15
