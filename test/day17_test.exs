defmodule Day17Test do
  use ExUnit.Case

  @test """
  .#.
  ..#
  ###
  """

  test "test 1" do
    assert @test |> Day17.parse() |> Day17.run() == 112
  end

  test "part 1" do
    assert Day17.part1() == 286
  end

  test "test 2" do
    assert @test |> Day17.parse2() |> Day17.run2() == 848
  end

  test "part 2" do
    assert Day17.part2() == 960
  end
end
