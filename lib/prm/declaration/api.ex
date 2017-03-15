defmodule PRM.DeclarationAPI do
  @moduledoc """
  The boundary for the DeclarationAPI system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias PRM.Repo

  alias PRM.Declaration

  def list_declarations do
    Repo.all(Declaration)
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
      title
      specialty
      start_date
      end_date
      active
      created_by
      updated_by
      doctor_id
      msp_id
    )

    declaration
    |> cast(attrs, fields)
  end
end
