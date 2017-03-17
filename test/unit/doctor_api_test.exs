defmodule PRM.Unit.DoctorAPITest do
  @moduledoc false

  use PRM.UnitCase, async: true

  alias PRM.DoctorAPI

  test "success search doctors by ids" do
    doctor = doctor()

    assert {:ok, doctors} = DoctorAPI.search_doctors(%{"ids" => [doctor.id]})
    assert is_list(doctors)
    assert 1 == length(doctors)
    assert doctor.id == List.first(doctors).id
  end
end
