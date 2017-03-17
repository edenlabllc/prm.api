if System.get_env("CONTAINER_HTTP_PORT") == nil do
  ExUnit.configure(exclude: [acceptance: true])
  Ecto.Adapters.SQL.Sandbox.mode(PRM.Repo, :manual)
end

ExUnit.start()
