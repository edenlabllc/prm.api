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

  def create_global_parameter(attrs) do
    %GlobalParameter{}
    |> global_parameter_changeset(attrs)
    |> Repo.insert_and_log()
  end

  def update_global_parameter(%GlobalParameter{} = global_parameter, attrs) do
    global_parameter
    |> global_parameter_changeset(attrs)
    |> Repo.update_and_log()
  end

  def create_or_update_global_parameters(params, x_consumer_id) do
    result =
      params
      |> Map.keys()
      |> Enum.reduce_while(nil, fn(x, _acc) -> process_global_parameters(x, params, x_consumer_id) end)

    case result do
      nil -> {:ok, list_global_parameters()}
      error -> error
    end
  end

  defp process_global_parameters(x, params, x_consumer_id) do
    case create_or_update_global_parameters(x, Map.get(params, x), x_consumer_id) do
      {:ok, _} -> {:cont, nil}
      {:error, _} = error -> {:halt, error}
    end
  end

  defp create_or_update_global_parameters(key, value, x_consumer_id) do
    case Repo.get_by(GlobalParameter, parameter: key) do
      %GlobalParameter{} = global_parameter ->
        update_global_parameter(global_parameter, %{value: value, updated_by: x_consumer_id})
      nil ->
        create_global_parameter(%{parameter: key, value: value, inserted_by: x_consumer_id, updated_by: x_consumer_id})
    end
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
