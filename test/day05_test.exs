defmodule Day05Test do
  use ExUnit.Case

  test "test 1" do
    assert Day05.decode("FBFBBFFRLR") == 357
    assert Day05.decode("BFFFBBFRRR") == 567
    assert Day05.decode("FFFBBBFRRR") == 119
    assert Day05.decode("BBFFBBFRLL") == 820
  end

  test "part 1" do
    assert Day05.part1() == 855
  end

  test "part 2" do
    assert Day05.part2() == 552
  end
end
