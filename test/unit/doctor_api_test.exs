defmodule PRM.Unit.DoctorAPITest do
  @moduledoc false

  use PRM.UnitCase, async: true

  alias PRM.DoctorAPI

  test "success search doctors by ids" do
    doctor = doctor()

    assert {:ok, [found_doctor]} = DoctorAPI.search_doctors(%{"ids" => [doctor.id]})
    assert doctor.id == found_doctor.id
  end
end
