# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :prm,
  ecto_repos: [PRM.Repo],
  namespace: PRM,
  divisions_per_page: {:system, :integer, "DIVISIONS_PER_PAGE", 15},
  employees_per_page: {:system, :integer, "EMPLOYEES_PER_PAGE", 50},
  legal_entities_per_page: {:system, :integer, "LEGAL_ENTITIES_PER_PAGE", 50}

# Configures the endpoint
config :prm, PRM.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "k/YvvNplW5/9q5BSuZH7O3y4kqqXeqUYwavMAPmUNJUGX3YPXU9JbB+iNgnIOMqm",
  render_errors: [view: EView.Views.PhoenixError, accepts: ~w(json)]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configure JSON Logger back-end
config :logger_json, :backend,
  on_init: {PRM.Application, :load_from_system_env, []},
  json_encoder: Poison,
  metadata: :all

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
