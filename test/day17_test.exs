defmodule Day17Test do
  use ExUnit.Case

  @test """
  .#.
  ..#
  ###
  """

  test "test 1" do
    assert @test |> Day17.parse(:dim3) |> Day17.run_cycles(:dim3) == 112
  end

  test "part 1" do
    assert Day17.part1() == 286
  end

  test "test 2" do
    assert @test |> Day17.parse(:dim4) |> Day17.run_cycles(:dim4) == 848
  end

  test "part 2" do
    assert Day17.part2() == 960
  end
end
