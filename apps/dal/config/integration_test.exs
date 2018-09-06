use Mix.Config

# Configure your database
config :dal, DAL.Repo,
adapter: Ecto.Adapters.Postgres,
username: "postgres",
password: "p@ssw0rd",
database: "EducationAPI_DAL_dev",
hostname: "localhost",
pool: Ecto.Adapters.SQL.Sandbox

