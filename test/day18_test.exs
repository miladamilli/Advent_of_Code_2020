defmodule Day18Test do
  use ExUnit.Case

  test "part 1" do
    assert Day18.part1() == 69_490_582_260
  end

  test "test 2" do
    assert Day18.run2(["1 + 2 * 3 + 4 * 5 + 6"]) == 231
    assert Day18.run2(["1 + (2 * 3) + (4 * (5 + 6))"]) == 51
    assert Day18.run2(["2 * 3 + (4 * 5)"]) == 46
    assert Day18.run2(["5 + (8 * 3 + 9 + 3 * 4 * 3)"]) == 1445
    assert Day18.run2(["5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))"]) == 669_060
    assert Day18.run2(["((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"]) == 23340
  end

  test "part 2" do
    assert Day18.part2() == 362_464_596_624_526
  end
end
