defmodule PRM.Unit.DoctorTest do
  @moduledoc false

  use PRM.UnitCase, async: true

  test "record is successfully saved to DB" do
    params = %{
      mpi_id: "some_mpi_id_string",
      status: "some_status_string",
      education: [],
      certificates: [],
      licenses: [],
      jobs: [],
      active: true,
      name: "Vasilii Poupkine",
      created_by: "some_author_identifier",
      updated_by: "some_editor_identifier"
    }

    assert {:ok, _} = PRM.Doctor.insert(params)
  end
end
