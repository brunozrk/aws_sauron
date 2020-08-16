import Config
require Logger

secret_key_base =
  if System.get_env("SECRET_KEY_BASE") do
    System.get_env("SECRET_KEY_BASE")
  else
    Logger.warn("""
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """)

    "X/5+WZRfqpj5hJuBwmjpaeJNBsJqSzCLp/xTXHihtNXQFPbp5dYbd4Q9JIc7/oaC"
  end

config :web, Web.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

config :ex_aws,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  region: System.get_env("AWS_REGION") || "us-east-1",
  json_codec: Jason

config :web, Web.Endpoint, server: true
