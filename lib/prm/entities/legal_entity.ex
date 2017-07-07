defmodule PRM.Entities.LegalEntity do
  @moduledoc false

  use Ecto.Schema

  @status_active "ACTIVE"
  @status_closed "CLOSED"

  @mis_verified_verified "VERIFIED"
  @mis_verified_not_verified "NOT_VERIFIED"

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "legal_entities" do
    field :is_active, :boolean, default: false
    field :nhs_verified, :boolean, default: false
    field :addresses, {:array, :map}
    field :edrpou, :string
    field :email, :string
    field :kveds, {:array, :string}
    field :legal_form, :string
    field :name, :string
    field :owner_property_type, :string
    field :phones, {:array, :map}
    field :public_name, :string
    field :short_name, :string
    field :status, :string
    field :mis_verified, :string
    field :type, :string
    field :inserted_by, Ecto.UUID
    field :updated_by, Ecto.UUID
    field :capitation_contract_id, :id
    field :created_by_mis_client_id, Ecto.UUID

    has_one :medical_service_provider, {"medical_service_providers", PRM.Entities.MSP}, on_replace: :delete

    timestamps()
  end

  def status(:active), do: @status_active

  def status(:closed), do: @status_closed

  def mis_verified(:verified), do: @mis_verified_verified

  def mis_verified(:not_verified), do: @mis_verified_not_verified
end
