defmodule Prm.Unit.DoctorTest do
  @moduledoc false

  use Prm.UnitCase, async: true

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

    assert {:ok, _} = Prm.Doctor.insert(params)
  end
end
