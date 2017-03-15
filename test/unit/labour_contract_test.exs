defmodule PRM.Unit.LabourContractTest do
  @moduledoc false

  use PRM.UnitCase, async: true

  test "record is successfully saved to DB" do
    params = %{
      start_date: "2016-10-10 23:50:07",
      end_date: "2016-12-07 23:50:07",
      status: "some_status_string",
      signed_at: "2016-10-09 23:50:07",
      services: [],
      title: "some_title",
      specialty: "some_specialty_string",
      start_date: "2016-10-10 23:50:07",
      end_date: "2016-12-07 23:50:07",
      active: true,
      created_by: "some_author_identifier",
      updated_by: "some_editor_identifier",
      doctor_id: doctor().id,
      msp_id: msp().id
    }

    assert {:ok, _} = PRM.LabourContract.insert(params)
  end
end
