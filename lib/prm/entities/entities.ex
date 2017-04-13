defmodule PRM.Entities do
  @moduledoc """
  The boundary for the Entities system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias PRM.Repo

  alias PRM.Entities.LegalEntity

  @doc """
  Returns the list of legal_entities.

  ## Examples

      iex> list_legal_entities()
      [%LegalEntity{}, ...]

  """
  def list_legal_entities do
    Repo.all(LegalEntity)
  end

  @doc """
  Gets a single legal_entity.

  Raises `Ecto.NoResultsError` if the Legal entity does not exist.

  ## Examples

      iex> get_legal_entity!(123)
      %LegalEntity{}

      iex> get_legal_entity!(456)
      ** (Ecto.NoResultsError)

  """
  def get_legal_entity!(id), do: Repo.get!(LegalEntity, id)

  @doc """
  Creates a legal_entity.

  ## Examples

      iex> create_legal_entity(%{field: value})
      {:ok, %LegalEntity{}}

      iex> create_legal_entity(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_legal_entity(attrs \\ %{}) do
    %LegalEntity{}
    |> legal_entity_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a legal_entity.

  ## Examples

      iex> update_legal_entity(legal_entity, %{field: new_value})
      {:ok, %LegalEntity{}}

      iex> update_legal_entity(legal_entity, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_legal_entity(%LegalEntity{} = legal_entity, attrs) do
    legal_entity
    |> legal_entity_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a LegalEntity.

  ## Examples

      iex> delete_legal_entity(legal_entity)
      {:ok, %LegalEntity{}}

      iex> delete_legal_entity(legal_entity)
      {:error, %Ecto.Changeset{}}

  """
  def delete_legal_entity(%LegalEntity{} = legal_entity) do
    Repo.delete(legal_entity)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking legal_entity changes.

  ## Examples

      iex> change_legal_entity(legal_entity)
      %Ecto.Changeset{source: %LegalEntity{}}

  """
  def change_legal_entity(%LegalEntity{} = legal_entity) do
    legal_entity_changeset(legal_entity, %{})
  end

  defp legal_entity_changeset(%LegalEntity{} = legal_entity, attrs) do
    legal_entity
    |> cast(attrs, [:name, :short_name, :public_name, :status, :type, :owner_property_type, :legal_form, :edrpou, :kveds, :addresses, :phones, :email, :active, :created_by, :updated_by])
    |> validate_required([:name, :short_name, :public_name, :status, :type, :owner_property_type, :legal_form, :edrpou, :kveds, :addresses, :phones, :email, :active, :created_by, :updated_by])
  end

  alias PRM.Entities.MSP

  @doc """
  Returns the list of medical_service_providers.

  ## Examples

      iex> list_medical_service_providers()
      [%MSP{}, ...]

  """
  def list_medical_service_providers do
    Repo.all(MSP)
  end

  @doc """
  Gets a single msp.

  Raises `Ecto.NoResultsError` if the Msp does not exist.

  ## Examples

      iex> get_msp!(123)
      %MSP{}

      iex> get_msp!(456)
      ** (Ecto.NoResultsError)

  """
  def get_msp!(id), do: Repo.get!(MSP, id)

  @doc """
  Creates a msp.

  ## Examples

      iex> create_msp(%{field: value})
      {:ok, %MSP{}}

      iex> create_msp(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_msp(attrs \\ %{}) do
    %MSP{}
    |> msp_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a msp.

  ## Examples

      iex> update_msp(msp, %{field: new_value})
      {:ok, %MSP{}}

      iex> update_msp(msp, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_msp(%MSP{} = msp, attrs) do
    msp
    |> msp_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a MSP.

  ## Examples

      iex> delete_msp(msp)
      {:ok, %MSP{}}

      iex> delete_msp(msp)
      {:error, %Ecto.Changeset{}}

  """
  def delete_msp(%MSP{} = msp) do
    Repo.delete(msp)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking msp changes.

  ## Examples

      iex> change_msp(msp)
      %Ecto.Changeset{source: %MSP{}}

  """
  def change_msp(%MSP{} = msp) do
    msp_changeset(msp, %{})
  end

  defp msp_changeset(%MSP{} = msp, attrs) do
    msp
    |> cast(attrs, [:accreditation, :license])
    |> validate_required([:accreditation, :license])
  end

  alias PRM.Entities.Division

  @doc """
  Returns the list of divisions.

  ## Examples

      iex> list_divisions()
      [%Division{}, ...]

  """
  def list_divisions do
    Repo.all(Division)
  end

  @doc """
  Gets a single division.

  Raises `Ecto.NoResultsError` if the Division does not exist.

  ## Examples

      iex> get_division!(123)
      %Division{}

      iex> get_division!(456)
      ** (Ecto.NoResultsError)

  """
  def get_division!(id), do: Repo.get!(Division, id)

  @doc """
  Creates a division.

  ## Examples

      iex> create_division(%{field: value})
      {:ok, %Division{}}

      iex> create_division(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_division(attrs \\ %{}) do
    %Division{}
    |> division_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a division.

  ## Examples

      iex> update_division(division, %{field: new_value})
      {:ok, %Division{}}

      iex> update_division(division, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_division(%Division{} = division, attrs) do
    division
    |> division_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Division.

  ## Examples

      iex> delete_division(division)
      {:ok, %Division{}}

      iex> delete_division(division)
      {:error, %Ecto.Changeset{}}

  """
  def delete_division(%Division{} = division) do
    Repo.delete(division)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking division changes.

  ## Examples

      iex> change_division(division)
      %Ecto.Changeset{source: %Division{}}

  """
  def change_division(%Division{} = division) do
    division_changeset(division, %{})
  end

  defp division_changeset(%Division{} = division, attrs) do
    division
    |> cast(attrs, [:external_id, :name, :type, :mountain_group, :address, :phones, :email])
    |> validate_required([:external_id, :name, :type, :mountain_group, :address, :phones, :email])
  end
end
