defmodule Day10Test do
  use ExUnit.Case

  @input1 """
  16
  10
  15
  5
  1
  11
  7
  19
  6
  12
  4
  """

  test "test 1" do
    assert @input1 |> Day10.parse_input() |> Day10.run() == 7 * 5
  end

  @input2 """
  28
  33
  18
  42
  31
  14
  46
  20
  48
  47
  24
  23
  49
  45
  19
  38
  39
  11
  1
  32
  25
  35
  8
  17
  7
  9
  4
  2
  34
  10
  3
  """

  test "test 2" do
    assert @input2 |> Day10.parse_input() |> Day10.run() == 22 * 10
  end

  test "part 1" do
    assert Day10.part1() == 1998
  end

  test "test2 1" do
    assert @input1 |> Day10.parse_input() |> Day10.run2() == 8
  end

  test "part 2" do
    assert Day10.part2() == 347_250_213_298_688
  end
end
