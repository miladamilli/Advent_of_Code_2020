defmodule Day11Test do
  use ExUnit.Case

  @seats """
  L.LL.LL.LL
  LLLLLLL.LL
  L.L.L..L..
  LLLL.LL.LL
  L.LL.LL.LL
  L.LLLLL.LL
  ..L.L.....
  LLLLLLLLLL
  L.LLLLLL.L
  L.LLLLL.LL
  """
  test "test 1" do
    assert @seats |> Day11.run() == 37
  end

  test "part 1" do
    assert Day11.part1() == 2204
  end

  test "test 2" do
    assert @seats |> Day11.run2() == 26
  end

  test "part 2" do
    assert Day11.part2() == 1986
  end
end
