defmodule PRM.Entities.MSP do
  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset, warn: false

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "medical_service_providers" do
    field :accreditation, :map
    field :licenses, {:array, :map}

    belongs_to :legal_entity, PRM.Entities.LegalEntity, type: Ecto.UUID

    timestamps()
  end

  @fields ~W(
    accreditation
    licenses
  )a

  def changeset(%PRM.Entities.MSP{} = doc, attrs) do
    doc
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end
end
