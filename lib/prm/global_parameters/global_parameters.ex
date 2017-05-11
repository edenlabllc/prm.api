defmodule PRM.GlobalParameters do
  @moduledoc """
  The boundary for the Global parameters system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias PRM.Repo

  alias PRM.GlobalParameters.GlobalParameter

  def list_global_parameters do
    query = from gp in GlobalParameter,
      order_by: [desc: :inserted_at]

    Repo.all(query)
  end
end
