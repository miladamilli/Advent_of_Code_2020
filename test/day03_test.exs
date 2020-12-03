defmodule Day03Test do
  use ExUnit.Case

  @input1 """
  ..##.......
  #...#...#..
  .#....#..#.
  ..#.#...#.#
  .#...##..#.
  ..#.##.....
  .#.#.#....#
  .#........#
  #.##...#...
  #...##....#
  .#..#...#.#
  """

  test "test 1 " do
    input = Day03.parse_input(@input1)

    assert Day03.count_trees(input, 3, 1) == 7
  end

  test "part 1" do
    assert Day03.part1() == 247
  end

  test "test 2" do
    input = Day03.parse_input(@input1)

    result =
      Day03.count_trees(input, 1, 1) *
        Day03.count_trees(input, 3, 1) *
        Day03.count_trees(input, 5, 1) *
        Day03.count_trees(input, 7, 1) *
        Day03.count_trees(input, 1, 2)

    assert result == 336
  end

  test "part 2" do
    assert Day03.part2() == 2_983_070_376
  end
end
