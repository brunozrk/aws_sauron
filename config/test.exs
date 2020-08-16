use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :web, Web.Endpoint,
  http: [port: 4002],
  server: false

config :logger, :console, level: :info

config :server, :aws_mod, Server.Aws.Mock
