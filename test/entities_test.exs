defmodule PRM.EntitiesTest do
  use PRM.DataCase

  alias PRM.Entities
  alias PRM.Entities.LegalEntity

  @create_attrs %{active: true, addresses: %{}, created_by: "some created_by", edrpou: 42, email: "some email", kveds: %{}, legal_form: "some legal_form", name: "some name", owner_property_type: "some owner_property_type", phones: %{}, public_name: "some public_name", short_name: "some short_name", status: "some status", type: "some type", updated_by: "some updated_by"}
  @update_attrs %{active: false, addresses: %{}, created_by: "some updated created_by", edrpou: 43, email: "some updated email", kveds: %{}, legal_form: "some updated legal_form", name: "some updated name", owner_property_type: "some updated owner_property_type", phones: %{}, public_name: "some updated public_name", short_name: "some updated short_name", status: "some updated status", type: "some updated type", updated_by: "some updated updated_by"}
  @invalid_attrs %{active: nil, addresses: nil, created_by: nil, edrpou: nil, email: nil, kveds: nil, legal_form: nil, name: nil, owner_property_type: nil, phones: nil, public_name: nil, short_name: nil, status: nil, type: nil, updated_by: nil}

  def fixture(:legal_entity, attrs \\ @create_attrs) do
    {:ok, legal_entity} = Entities.create_legal_entity(attrs)
    legal_entity
  end

  test "list_legal_entities/1 returns all legal_entities" do
    legal_entity = fixture(:legal_entity)
    assert Entities.list_legal_entities() == [legal_entity]
  end

  test "get_legal_entity! returns the legal_entity with given id" do
    legal_entity = fixture(:legal_entity)
    assert Entities.get_legal_entity!(legal_entity.id) == legal_entity
  end

  test "create_legal_entity/1 with valid data creates a legal_entity" do
    assert {:ok, %LegalEntity{} = legal_entity} = Entities.create_legal_entity(@create_attrs)
    assert legal_entity.active == true
    assert legal_entity.addresses == %{}
    assert legal_entity.created_by == "some created_by"
    assert legal_entity.edrpou == 42
    assert legal_entity.email == "some email"
    assert legal_entity.kveds == %{}
    assert legal_entity.legal_form == "some legal_form"
    assert legal_entity.name == "some name"
    assert legal_entity.owner_property_type == "some owner_property_type"
    assert legal_entity.phones == %{}
    assert legal_entity.public_name == "some public_name"
    assert legal_entity.short_name == "some short_name"
    assert legal_entity.status == "some status"
    assert legal_entity.type == "some type"
    assert legal_entity.updated_by == "some updated_by"
  end

  test "create_legal_entity/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Entities.create_legal_entity(@invalid_attrs)
  end

  test "update_legal_entity/2 with valid data updates the legal_entity" do
    legal_entity = fixture(:legal_entity)
    assert {:ok, legal_entity} = Entities.update_legal_entity(legal_entity, @update_attrs)
    assert %LegalEntity{} = legal_entity
    assert legal_entity.active == false
    assert legal_entity.addresses == %{}
    assert legal_entity.created_by == "some updated created_by"
    assert legal_entity.edrpou == 43
    assert legal_entity.email == "some updated email"
    assert legal_entity.kveds == %{}
    assert legal_entity.legal_form == "some updated legal_form"
    assert legal_entity.name == "some updated name"
    assert legal_entity.owner_property_type == "some updated owner_property_type"
    assert legal_entity.phones == %{}
    assert legal_entity.public_name == "some updated public_name"
    assert legal_entity.short_name == "some updated short_name"
    assert legal_entity.short_name == "some updated short_name"
    assert legal_entity.status == "some updated status"
    assert legal_entity.type == "some updated type"
    assert legal_entity.updated_by == "some updated updated_by"
  end

  test "update_legal_entity/2 with invalid data returns error changeset" do
    legal_entity = fixture(:legal_entity)
    assert {:error, %Ecto.Changeset{}} = Entities.update_legal_entity(legal_entity, @invalid_attrs)
    assert legal_entity == Entities.get_legal_entity!(legal_entity.id)
  end

  test "change_legal_entity/1 returns a legal_entity changeset" do
    legal_entity = fixture(:legal_entity)
    assert %Ecto.Changeset{} = Entities.change_legal_entity(legal_entity)
  end
end
