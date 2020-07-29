# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

config :web,
  generators: [context_app: false]

# Configures the endpoint
config :web, Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qhhUB4GPSaNRmUABio/aM9tdddIZkVpv4XyPyp0Wj+VI3Q/l4fF7yfJUCyifbmEl",
  render_errors: [view: Web.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Web.PubSub,
  live_view: [signing_salt: "OSHIxSWO"]

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]
#

config :ex_aws,
  # access_key_id: {:system, "AWS_ACCESS_KEY_ID"},
  # secret_access_key: {:system, "AWS_SECRET_ACCESS_KEY"}
  region: System.get_env("AWS_REGION") || "sa-east-1",
  json_codec: Jason

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
