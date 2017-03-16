if System.get_env("CONTAINER_HTTP_PORT") == nil do
  Ecto.Adapters.SQL.Sandbox.mode(PRM.Repo, :manual)
end

ExUnit.start()
