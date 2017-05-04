defmodule PRM.Web.PartyControllerTest do
  use PRM.Web.ConnCase

  import PRM.SimpleFactory

  alias PRM.Parties.Party

  @create_attrs %{
    birth_date: ~D[1987-04-17],
    documents: [
      %{
        type: "NATIONAL_ID",
        number: "AA000000"
      }
    ],
    first_name: "some first_name",
    gender: "some gender",
    last_name: "some last_name",
    phones: [
      %{
        type: "MOBILE",
        number: "+380671112233"
      }
    ],
    second_name: "some second_name",
    tax_id: "some tax_id",
    inserted_by: "b17f0f82-4152-459e-9f10-a6662dfc0cf0",
    updated_by: "b17f0f82-4152-459e-9f10-a6662dfc0cf0"
  }

  @update_attrs %{
    birth_date: ~D[1998-05-18],
    documents: [
      %{
        type: "NATIONAL_ID",
        number: "AA000001"
      }
    ],
    first_name: "some updated first_name",
    gender: "some updated gender",
    last_name: "some updated last_name",
    phones: [
      %{
        type: "MOBILE",
        number: "+380671112277"
      }
    ],
    second_name: "some updated second_name",
    tax_id: "some updated tax_id",
    updated_by: "b17f0f82-4152-459e-9f10-a6662dfc0cf0"
  }

  @invalid_attrs %{
    birth_date: nil,
    inserted_by: nil,
    documents: nil,
    first_name: nil,
    gender: nil,
    last_name: nil,
    phones: nil,
    second_name: nil,
    tax_id: nil,
    updated_by: nil
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    fixture(:party)
    fixture(:party)
    fixture(:party)
    fixture(:party)

    conn = get conn, party_path(conn, :index, [limit: 2])
    resp = json_response(conn, 200)

    assert Map.has_key?(resp, "paging")
    assert 2 == length(resp["data"])
    assert resp["paging"]["has_more"]
  end

  test "search parties by phone_number", %{conn: conn} do
    number = "+380991119900"
    party(number)
    party()
    party()

    conn = get conn, party_path(conn, :index, [phone_number: number])
    resp = json_response(conn, 200)

    assert Map.has_key?(resp, "paging")
    assert 1 == length(resp["data"])
    refute resp["paging"]["has_more"]
  end

  test "creates party and renders party when data is valid", %{conn: conn} do
    conn = post conn, party_path(conn, :create), party: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, party_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "birth_date" => "1987-04-17",
      "documents" => [
        %{
          "type" => "NATIONAL_ID",
          "number" => "AA000000"
        }
      ],
      "first_name" => "some first_name",
      "gender" => "some gender",
      "last_name" => "some last_name",
      "phones" => [
        %{
          "type" => "MOBILE",
          "number" => "+380671112233"
        }
      ],
      "type" => "party", # EView field
      "second_name" => "some second_name",
      "tax_id" => "some tax_id",
      "inserted_by" => "b17f0f82-4152-459e-9f10-a6662dfc0cf0",
      "updated_by" => "b17f0f82-4152-459e-9f10-a6662dfc0cf0"
    }
  end

  test "does not create party and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, party_path(conn, :create), party: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen party and renders party when data is valid", %{conn: conn} do
    %Party{id: id} = party = fixture(:party)
    conn = put conn, party_path(conn, :update, party), party: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, party_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "birth_date" => "1998-05-18",
      "documents" => [
        %{
          "type" => "NATIONAL_ID",
          "number" => "AA000001"
        }
      ],
      "first_name" => "some updated first_name",
      "gender" => "some updated gender",
      "last_name" => "some updated last_name",
      "phones" => [
        %{
          "type" => "MOBILE",
          "number" => "+380671112277"
        }
      ],
      "type" => "party", # EView field
      "second_name" => "some updated second_name",
      "tax_id" => "some updated tax_id",
      "inserted_by" => "b17f0f82-4152-459e-9f10-a6662dfc0cf0",
      "updated_by" => "b17f0f82-4152-459e-9f10-a6662dfc0cf0"
    }
  end

  test "does not update chosen party and renders errors when data is invalid", %{conn: conn} do
    party = fixture(:party)
    conn = put conn, party_path(conn, :update, party), party: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end
end
