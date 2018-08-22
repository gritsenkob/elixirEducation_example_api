# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :api,
  namespace: API

# Configures the endpoint
config :api, APIWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "EqlecwPht4sooV1RAZhmnU+T1Sxs40J8T0Ohvjkyzv7eotop8QQv977jKtnXAOId",
  render_errors: [view: APIWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: API.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
