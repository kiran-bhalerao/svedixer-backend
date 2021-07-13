# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :svedixer,
  ecto_repos: [Svedixer.Repo],
  generators: [binary_id: true]

config :svedixer, Svedixer.Guardian,
  issuer: "svedixer",
  ttl: {365, :days},
  secret_key: "HSJexbz1LbdoqbL3dPS9uXHAqK74yXLfpbAcN7bEox8KdH12pweg0En+UX1Rd448"

# Configures the endpoint
config :svedixer, SvedixerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "yB2SGRnsfKGXrtTTIhNAAirXUhOHTqBse2XhxtsxELsPXWtlxokTGIs+kBhjHmVu",
  render_errors: [view: SvedixerWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: Svedixer.PubSub,
  live_view: [signing_salt: "kaRXrxX2"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
