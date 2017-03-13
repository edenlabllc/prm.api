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

  using do
    quote do
      alias PRM.Repo

      import Prm.SimpleFactory
    end
  end
end
