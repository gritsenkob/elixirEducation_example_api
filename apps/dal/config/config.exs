use Mix.Config

config :dal, ecto_repos: [DAL.Repo]

import_config "#{Mix.env}.exs"
