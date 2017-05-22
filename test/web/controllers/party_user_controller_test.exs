defmodule PRM.Web.PartyUserControllerTest do
  use PRM.Web.ConnCase

  import PRM.SimpleFactory

  alias Ecto.UUID
  alias PRM.Parties.Party
  alias PRM.Parties.PartyUser

  @invalid_attrs %{
    party_id: "230CF611-64BD-4EEF-ACB1-1565EF5665AD",
    user_id: "1000"
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, party_user_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "search parties by user_id", %{conn: conn} do
    user_id = UUID.generate()
    party_user(user_id)
    fixture(:party_user)
    fixture(:party_user)

    conn = get conn, party_user_path(conn, :index, [user_id: user_id])
    resp = json_response(conn, 200)

    assert Map.has_key?(resp, "paging")
    assert 1 == length(resp["data"])
    refute resp["paging"]["has_more"]
    assert user_id == resp["data"] |> List.first() |> Map.get("user_id")
  end

  test "creates party_user and renders party_user when data is valid", %{conn: conn} do
    %Party{id: party_id} = fixture(:party)
    user_id = UUID.generate()
    conn = post conn, party_user_path(conn, :create), %{party_id: party_id, user_id: user_id}
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, party_user_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "user_id" => user_id,
      "party_id" => party_id,
    }
  end

  test "does not create party_user and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, party_user_path(conn, :create), @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen party_user and renders party_user when data is valid", %{conn: conn} do
    %PartyUser{id: id} = party_user = fixture(:party_user)
    user_id = UUID.generate()
    conn = put conn, party_user_path(conn, :update, party_user), %{user_id: user_id}
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, party_user_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "user_id" => user_id,
      "party_id" => party_user.party_id,
    }
  end

  test "does not update chosen party_user and renders errors when data is invalid", %{conn: conn} do
    party_user = fixture(:party_user)
    conn = put conn, party_user_path(conn, :update, party_user), @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end
end
