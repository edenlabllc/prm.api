defmodule PRM.Unit.ProductTest do
  @moduledoc false

  use PRM.UnitCase, async: true

  test "record is successfully saved to DB" do
    params = %{
      name: "some_name",
      parameters: %{},
    }

    assert {:ok, _} = PRM.Schemas.Product.insert(params)
  end
end
