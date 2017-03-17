defmodule PRM.DeclarationAPI do
  @moduledoc """
  The boundary for the DeclarationAPI system
  """

  import Ecto.{Query, Changeset}, warn: false
  alias PRM.Repo

  alias PRM.Declaration

  def list_declarations(params) do
    changeset = declaration_search_changeset(%Declaration{}, params)

    if changeset.valid? do
      query = from d in Declaration, where: ^Enum.into(changeset.changes, [])

      Repo.all(query)
    else
      Repo.all(Declaration)
    end
  end

  def get_declaration!(id), do: Repo.get!(Declaration, id)

  def create_declaration(attrs \\ %{}) do
    %Declaration{}
    |> declaration_changeset(attrs)
    |> Repo.insert()
  end

  def update_declaration(%Declaration{} = declaration, attrs) do
    declaration
    |> declaration_changeset(attrs)
    |> Repo.update()
  end

  def delete_declaration(%Declaration{} = declaration) do
    Repo.delete(declaration)
  end

  def change_declaration(%Declaration{} = declaration) do
    declaration_changeset(declaration, %{})
  end

  defp declaration_changeset(%Declaration{} = declaration, attrs) do
    fields = ~W(
      patient_id
      start_date
      end_date
      signature
      certificate
      status
      signed_at
      created_by
      updated_by
      confident_person_id
      active
      doctor_id
      msp_id
    )

    declaration
    |> cast(attrs, fields)
  end

  defp declaration_search_changeset(%Declaration{} = declaration, attrs) do
    fields = [
      :patient_id,
      :active,
      :doctor_id,
      :msp_id
    ]

    declaration
    |> cast(attrs, fields)
    |> validate_any_is_present(fields)
  end

  defp validate_any_is_present(changeset, fields) do
    if Enum.any?(fields, &present?(changeset, &1)) do
      changeset
    else
      message = "One of these fields must be present: #{inspect fields}"
      add_error(changeset, hd(fields), message)
    end
  end

  defp present?(changeset, field) do
    case fetch_change(changeset, field) do
      :error -> false
      {:ok, ""} -> false
      {:ok, _} -> true
    end
  end
end
