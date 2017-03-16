defmodule PRM.Unit.DoctorAPITest do
  @moduledoc false

  use PRM.UnitCase, async: true

  alias PRM.DoctorAPI
  alias PRM.DoctorSearch

  test "search doctor validation" do
    assert %{valid?: false} = DoctorSearch.validate(%{})
    assert %{valid?: false} = DoctorSearch.validate(%{"invalid" => true})
    assert %{valid?: false} = DoctorSearch.validate(%{"area" => nil})
    assert %{valid?: false} = DoctorSearch.validate(%{"area" => ""})

    fields = ~W(
      first_name
      last_name
      second_name
      speciality
      region
      area
    )
    for field <- fields,
        do: assert %{valid?: true} = DoctorSearch.validate(%{field => "value"})
  end

  test "success search doctor by area" do
#    doctor = doctor()
#    asserta = DoctorAPI.search_doctor(%{"first_name" => doctor.first_name})
  end
end
