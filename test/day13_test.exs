defmodule Day13Test do
  use ExUnit.Case

  @depart 939
  @buses "7,13,x,x,59,x,31,19"
  test "test 1" do
    assert Day13.run(@buses, @depart) == 295
  end

  test "part 1" do
    assert Day13.part1() == 2095
  end

  test "test 2" do
    assert "7,13,x,x,59,x,31,19" |> Day13.run2() == 1_068_781
  end

  test "part 2" do
    assert Day13.part2() == 598_411_311_431_841
  end
end
