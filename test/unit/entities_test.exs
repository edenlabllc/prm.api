defmodule PRM.Unit.EntitiesTest do
  use PRM.DataCase

  alias PRM.Entities
  alias PRM.Entities.LegalEntity

  @create_attrs %{
    is_active: true,
    addresses: [%{}],
    inserted_by: "b17f0f82-4152-459e-9f10-a6662dfc0cf0",
    edrpou: "04512341",
    email: "some email",
    kveds: [],
    legal_form: "some legal_form",
    name: "some name",
    owner_property_type: "STATE",
    phones: [%{}],
    public_name: "some public_name",
    short_name: "some short_name",
    status: "VERIFIED",
    type: "MSP",
    updated_by: "1fb706b3-dc1b-4116-a1fd-7f2c05a974ac",
    medical_service_provider: %{
      licenses: [%{
        license_number: "fd123443"
      }],
      accreditation: %{
        category: "перша",
        order_no: "me789123"
      }
    }
  }

  @update_attrs %{
    is_active: false,
    addresses: [%{}],
    inserted_by: "632d8c40-9c90-48fe-972b-6cc773dadfda",
    edrpou: "04512322",
    email: "some updated email",
    kveds: [],
    legal_form: "some updated legal_form",
    name: "some updated name",
    owner_property_type: "PRIVATE",
    phones: [%{}],
    public_name: "some updated public_name",
    short_name: "some updated short_name",
    status: "NOT_VERIFIED",
    type: "MIS",
    updated_by: "b1018644-6732-4045-a658-6a258f301600",
    medical_service_provider: %{
      licenses: [%{
        license_number: "10000"
      }],
      accreditation: %{
        category: "друга",
        order_no: "me789123"
      }
    }
  }

  @invalid_attrs %{
    is_active: false,
    addresses: nil,
    inserted_by: nil,
    edrpou: nil,
    email: nil,
    kveds: nil,
    legal_form: nil,
    name: nil,
    owner_property_type: nil,
    phones: nil,
    public_name: nil,
    short_name: nil,
    status: nil,
    type: nil,
    updated_by: nil
  }


  def fixture(:legal_entity, attrs \\ @create_attrs) do
    {:ok, legal_entity} = Entities.create_legal_entity(attrs)
    legal_entity
  end

  test "put id" do
    generated_id = Ecto.UUID.generate()

    legal_entity =
      @create_attrs
      |> Map.put(:id, generated_id)
      |> Entities.create_legal_entity()

    assert {:ok, %LegalEntity{id: ^generated_id}} = legal_entity
  end

  test "put invalid id" do
    generated_id = 1000

    legal_entity =
      @create_attrs
      |> Map.put(:id, generated_id)
      |> Entities.create_legal_entity()

    assert {:error, %Ecto.Changeset{valid?: false}} = legal_entity
  end

  test "msp accreditation is not required" do
    legal_entity =
      @create_attrs
      |> Map.put(:medical_service_provider, %{licenses: [%{license_number: "fd123443"}]})
      |> Entities.create_legal_entity()

    assert {:ok, %LegalEntity{}} = legal_entity
  end

  test "list_legal_entities/1 returns all legal_entities" do
    legal_entity = fixture(:legal_entity)
    assert {[loaded_legal_entity], %Ecto.Paging{}} = Entities.list_legal_entities(%{})

    assert Map.has_key?(loaded_legal_entity, :medical_service_provider)
    assert legal_entity.medical_service_provider.accreditation.category ==
      loaded_legal_entity.medical_service_provider.accreditation["category"]
  end

  test "get_legal_entity! returns the legal_entity with given id" do
    legal_entity = fixture(:legal_entity)
    loaded_legal_entity = Entities.get_legal_entity!(legal_entity.id)
    assert Map.has_key?(loaded_legal_entity, :medical_service_provider)
    assert legal_entity.medical_service_provider.accreditation.category ==
      loaded_legal_entity.medical_service_provider.accreditation["category"]
  end

  test "create_legal_entity/1 with valid data creates a legal_entity" do
    assert {:ok, %LegalEntity{} = legal_entity} = Entities.create_legal_entity(@create_attrs)
    assert legal_entity.is_active
    assert legal_entity.addresses == [%{}]
    assert legal_entity.inserted_by == "b17f0f82-4152-459e-9f10-a6662dfc0cf0"
    assert legal_entity.edrpou == "04512341"
    assert legal_entity.email == "some email"
    assert legal_entity.kveds == []
    assert legal_entity.legal_form == "some legal_form"
    assert legal_entity.name == "some name"
    assert legal_entity.owner_property_type == "STATE"
    assert legal_entity.phones == [%{}]
    assert legal_entity.public_name == "some public_name"
    assert legal_entity.short_name == "some short_name"
    assert legal_entity.status == "VERIFIED"
    assert legal_entity.type == "MSP"
    assert legal_entity.updated_by == "1fb706b3-dc1b-4116-a1fd-7f2c05a974ac"
  end

  test "create_legal_entity/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Entities.create_legal_entity(@invalid_attrs)
  end

  test "update_legal_entity/2 with valid data updates the legal_entity" do
    legal_entity = fixture(:legal_entity)
    assert {:ok, legal_entity} = Entities.update_legal_entity(legal_entity, @update_attrs)
    assert %LegalEntity{} = legal_entity
    refute legal_entity.is_active
    assert legal_entity.addresses == [%{}]
    assert legal_entity.inserted_by == "632d8c40-9c90-48fe-972b-6cc773dadfda"
    assert legal_entity.edrpou == "04512322"
    assert legal_entity.email == "some updated email"
    assert legal_entity.kveds == []
    assert legal_entity.legal_form == "some updated legal_form"
    assert legal_entity.name == "some updated name"
    assert legal_entity.owner_property_type == "PRIVATE"
    assert legal_entity.phones == [%{}]
    assert legal_entity.public_name == "some updated public_name"
    assert legal_entity.short_name == "some updated short_name"
    assert legal_entity.short_name == "some updated short_name"
    assert legal_entity.status == "NOT_VERIFIED"
    assert legal_entity.type == "MIS"
    assert legal_entity.updated_by == "b1018644-6732-4045-a658-6a258f301600"
  end

  test "update_legal_entity/2 with invalid data returns error changeset" do
    legal_entity = fixture(:legal_entity)
    assert {:error, %Ecto.Changeset{}} = Entities.update_legal_entity(legal_entity, @invalid_attrs)

    loaded_legal_entity = Entities.get_legal_entity!(legal_entity.id)
    assert Map.has_key?(loaded_legal_entity, :medical_service_provider)
    assert legal_entity.medical_service_provider.accreditation.category ==
      loaded_legal_entity.medical_service_provider.accreditation["category"]
  end

  test "change_legal_entity/1 returns a legal_entity changeset" do
    legal_entity = fixture(:legal_entity)
    assert %Ecto.Changeset{} = Entities.change_legal_entity(legal_entity)
  end
end
