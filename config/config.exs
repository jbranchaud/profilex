# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :profilex,
  ecto_repos: [Profilex.Repo]

# Configures the endpoint
config :profilex, Profilex.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "b8O6EEvLBbu80kzhwNcLFfLOPK6DdVGqc5XajupRa0eXkgSGfKLvTbjPscWOiOE+",
  render_errors: [view: Profilex.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Profilex.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
