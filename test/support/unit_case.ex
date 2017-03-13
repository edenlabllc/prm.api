defmodule Prm.UnitCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(PRM.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(PRM.Repo, {:shared, self()})
    end

    :ok
  end
end
