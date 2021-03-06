use Mix.Config

config :course_planner, CoursePlannerWeb.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn

config :course_planner, CoursePlanner.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "course_planner_test",
  hostname: System.get_env("DATABASE_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :course_planner, CoursePlanner.Mailer,
  adapter: Swoosh.Adapters.Test

config :comeonin,
  bcrypt_log_rounds: 4

config :coherence,
  email_from_name: "Test Name",
  email_from_email: "test@email"

config :course_planner, :notifier, CoursePlanner.TestNotifier
