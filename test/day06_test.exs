defmodule Day06Test do
  use ExUnit.Case

  test "part 1" do
    assert Day06.part1() == 6534
  end

  @answers """
  abc

  a
  b
  c

  ab
  ac

  a
  a
  a
  a

  b
  """
  test "test 2" do
    assert Day06.check_answers(@answers) == 6
  end

  test "part 2" do
    assert Day06.part2() == 3402
  end
end
