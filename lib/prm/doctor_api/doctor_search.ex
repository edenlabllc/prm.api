defmodule PRM.DoctorSearch do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset

  schema "doctors" do
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

  def validate_required_without(%Ecto.Changeset{} = ch, field, without) do
    without = List.wrap(without)
    with :error <- fetch_change(ch, without),
         false <- field_validation_failed?(ch, without)
         do validate_required(ch, [field], message: "custom")
    else
      _ -> ch
    end
  end

  def field_validation_failed?(%Ecto.Changeset{errors: errors} = ch, [head | tail]) do
    case field_validation_failed?(errors, head) do
      true -> true
      false -> field_validation_failed?(ch, tail)
    end
  end
  def field_validation_failed?(%Ecto.Changeset{errors: errors} = ch, []), do: false

  def field_validation_failed?(errors, field) when is_list(errors) do
    if Keyword.has_key?(errors, field) do
      case Keyword.fetch!(errors, field) do
        {_, [validation: :required]} -> false # ignore required validation
        _ -> true
      end
    else
      false
    end
  end
end
