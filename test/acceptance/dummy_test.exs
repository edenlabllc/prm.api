defmodule PRM.DummyAcceptanceTest do
  use PRM.Support.AcceptanceCase

  test "api" do
    "/api"
    |> get!()
    |> assert_status(200)
  end
end
