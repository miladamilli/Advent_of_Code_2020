defmodule Day12Test do
  use ExUnit.Case

  test "part 1" do
    assert Day12.part1() == 1106
  end

  @input """
  F10
  N3
  F7
  R90
  F11
  """
  test "test 2" do
    assert @input
           |> String.split("\n", trim: true)
           |> Day12.run2({0, 0}, {10, 1}) == 286
  end

  test "part 2" do
    assert Day12.part2() == 107_281
  end
end
