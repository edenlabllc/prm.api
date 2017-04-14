defmodule PRM.SimpleFactory do
  @moduledoc false

  alias PRM.Entities

  def fixture(:legal_entity), do: legal_entity()

  def legal_entity do
    attrs = %{
      "is_active" => true,
      "addresses" => %{},
      "created_by" => "026a8ea0-2114-11e7-8fae-685b35cd61c2",
      "edrpou" => "04512341",
      "email" => "some email",
      "kveds" => %{},
      "legal_form" => "some legal_form",
      "name" => "some name",
      "owner_property_type" => "STATE",
      "phones" => %{},
      "public_name" => "some public_name",
      "short_name" => "some short_name",
      "status" => "VERIFIED",
      "type" => "MSP",
      "updated_by" => "1729f790-2114-11e7-97f0-685b35cd61c2",
      "medical_service_provider" => %{
        "license" => %{
          "license_number" => "fd123443"
        },
        "accreditation" => %{
          "category" => "перша",
          "order_no" => "me789123"
        }
      }
    }
    {:ok, legal_entity} = Entities.create_legal_entity(attrs)
    legal_entity
  end

  def msp do
    %{
      id: "47e7f952-203f-11e7-bdfc-685b35cd61c2",
      name: "some_name",
      short_name: "some_shortname_string",
      type: "some_type_string",
      edrpou: "some_edrpou_string",
      services: [],
      licenses: [],
      accreditations: [],
      addresses: [],
      phones: [],
      emails: [],
      created_by: "some_author_identifier",
      updated_by: "some_editor_identifier",
      active: true
    }
  end

  def product do
    params = %{
      name: "some_name",
      parameters: %{}
    }

    params
    |> PRM.Product.insert
    |> elem(1)
  end
end
