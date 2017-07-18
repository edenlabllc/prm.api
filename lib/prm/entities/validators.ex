defmodule PRM.Entities.Validators do
  @moduledoc """
  Ecto validators for Legal Entity
  """
  import Ecto.Changeset, warn: false
  alias Ecto.UUID

  def validate_comma_params_uuid(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, comma_params ->
      comma_params
      |> String.split(",")
      |> valid_uuid_params?()
      |> case do
           true -> []
           false -> [{field, options[:message] || "Invalid UUID in #{field}"}]
         end
    end)
  end

  def valid_uuid_params?(comma_params) do
    Enum.reduce_while(comma_params, true, fn (i, acc) ->
      case UUID.cast(i) do
        {:ok, _} -> {:cont, acc}
        _        -> {:halt, false}
      end
    end)
  end
end
