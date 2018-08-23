use Mix.Config

# Configure your database
config :dal, DAL.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "DAL_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
