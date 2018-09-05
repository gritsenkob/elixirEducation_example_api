use Mix.Config

# Configure your database
config :dal, DAL.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "p@ssw0rd",
  database: "DAL_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
