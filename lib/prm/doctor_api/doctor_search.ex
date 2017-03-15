defmodule PRM.DoctorSearch do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  schema "doctor_search" do
    field :first_name, :string
    field :last_name, :string
    field :second_name, :string
    field :speciality, :string
    field :region, :string
    field :area, :string
  end

  def validate(attrs \\ %{}) do
    fields = ~W(
      first_name
      last_name
      second_name
      speciality
      region
      area
    )a

    %PRM.DoctorSearch{}
    |> cast(attrs, fields)
    |> validate_required_without(:first_name, List.delete(fields, :first_name))
    |> validate_required_without(:last_name, List.delete(fields, :last_name))
    |> validate_required_without(:second_name, List.delete(fields, :second_name))
    |> validate_required_without(:speciality, List.delete(fields, :speciality))
    |> validate_required_without(:region, List.delete(fields, :region))
    |> validate_required_without(:area, List.delete(fields, :area))
  end

  def validate_required_without(%{errors: errors} = changeset, field, fields_without, opts \\ []) do
    message = message(opts, "can't be blank without " <> Enum.join(fields_without, ", "))
    fields_without = List.wrap(fields_without)

    with true <- missing?(changeset, field),
         false <- field_present?(changeset, fields_without)
         do %{changeset | errors: [{field, {message, [validation: :required_without]}}] ++ errors, valid?: false}
    else
      _ -> changeset
    end
  end

  def field_present?(changeset, [head | tail]) do
    case field_present?(changeset, head) do
      false -> field_present?(changeset, tail)
      _ -> true
    end
  end
  def field_present?(_, []), do: false
  def field_present?(changeset, field) do
    with false <- missing?(changeset, field),
         true  <- ensure_field_exists!(changeset, field),
         true  <- validation_passed_except_required?(changeset, field)
         do true
    else
      _ -> false
    end
  end

  def validation_passed_except_required?(%Ecto.Changeset{errors: errors}, field) do
    if Keyword.has_key?(errors, field) do
      case Keyword.fetch!(errors, field) do
        {_, [validation: :required]} -> true
        _ -> false
      end
    end
    true
  end

  # Ecto.Changeset private functions. Added for integrity

  defp message(opts, key \\ :message, default) do
    Keyword.get(opts, key, default)
  end

  defp missing?(changeset, field) when is_atom(field) do
    case get_field(changeset, field) do
      %{__struct__: Ecto.Association.NotLoaded} ->
        raise ArgumentError, "attempting to validate association `#{field}` " <>
                             "that was not loaded. Please preload your associations " <>
                             "before calling validate_required/3 or pass the :required " <>
                             "option to Ecto.Changeset.cast_assoc/3"
      value when is_binary(value) -> String.trim_leading(value) == ""
      nil -> true
      _ -> false
    end
  end

  defp ensure_field_exists!(%Ecto.Changeset{types: types, data: data}, field) do
    unless Map.has_key?(types, field) do
      raise ArgumentError, "unknown field #{inspect field} for changeset on #{inspect data}"
    end
    true
  end
end
