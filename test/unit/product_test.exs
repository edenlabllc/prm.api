defmodule Prm.Unit.ProductTest do
  @moduledoc false

  use Prm.UnitCase, async: true

  test "record is successfully saved to DB" do
    params = %{
      name: "some_name",
      parameters: %{},
    }

    assert {:ok, _} = Prm.Product.insert(params)
  end
end
