defmodule Day09Test do
  use ExUnit.Case

  @input1 """
  35
  20
  15
  25
  47
  40
  62
  55
  65
  95
  102
  117
  150
  182
  127
  219
  299
  277
  309
  576
  """
  test "test 1" do
    assert @input1 |> Day09.parse_input() |> Day09.find_invalid_number(5) == 127
  end

  test "part 1" do
    assert Day09.part1() == 217_430_975
  end

  test "part 2" do
    assert Day09.part2() == 28_509_180
  end
end
