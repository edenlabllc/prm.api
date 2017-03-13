defmodule Prm.Unit.CapitationContractTest do
  use Prm.UnitCase, async: true

  test "record is successfully saved to DB" do
    params = %{
      start_date: "2016-10-10 23:50:07",
      end_date: "2016-12-07 23:50:07",
      status: "some_status_string",
      signed_at: "2016-10-09 23:50:07",
      services: [],
      product_id: product().id,
      msp_id: msp().id
    }

    assert {:ok, _} = Prm.CapitationContract.insert(params)
  end
end
