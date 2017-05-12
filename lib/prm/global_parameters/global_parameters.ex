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

  def create_global_parameter(attrs \\ %{}) do
    %GlobalParameter{}
    |> global_parameter_changeset(attrs)
    |> Repo.insert()
  end

  def update_global_parameter(%GlobalParameter{} = global_parameter, attrs) do
    global_parameter
    |> global_parameter_changeset(attrs)
    |> Repo.update()
  end

  defp global_parameter_changeset(%GlobalParameter{} = global_paramter, attrs) do
    fields = ~W(
      parameter
      value
      inserted_by
      updated_by
    )a

    global_paramter
    |> cast(attrs, fields)
    |> validate_required(fields)
  end
end
