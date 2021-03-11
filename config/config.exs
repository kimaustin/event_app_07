# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :event_app_07,
  ecto_repos: [EventApp07.Repo]

# Configures the endpoint
config :event_app_07, EventApp07Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7zLZEQO1UIl8EnZDTV+NfqfKW4IpVqiz6zzs8M03iAsOnvMV0OTkSYvmLEqY9Hlf",
  render_errors: [view: EventApp07Web.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: EventApp07.PubSub,
  live_view: [signing_salt: "jI8ZbQWT"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
