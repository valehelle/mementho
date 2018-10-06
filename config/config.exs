# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :mementho,
  ecto_repos: [Mementho.Repo]

# Configures the endpoint
config :mementho, MementhoWeb.Endpoint,
  url: [host: "127.0.0.1"],
  secret_key_base: "+8NY1XDsLph63CklWdSx0H3SV8449EagDTKfbMIlSjc39XnO6uwVKi6cB0KBy2ti",
  render_errors: [view: MementhoWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Mementho.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :mementho, Mementho.Accounts.Guardian,
  issuer: "mementho", # Name of your app/company/product
  secret_key: "sf/dnMKYVw9YfRs5mFDyPkT7Rm/bnatbEsf8QmJWLtf24PGhTCTF7dqU/9HogDTx",
  redirect_uri: "/user/sign_in"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
