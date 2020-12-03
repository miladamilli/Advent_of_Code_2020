defmodule Day03 do
  def part1 do
    input = parse_input(File.read!("input/day03.txt"))
    count_trees(input, 3, 1)
  end

  def part2 do
    input = parse_input(File.read!("input/day03.txt"))

    count_trees(input, 1, 1) *
      count_trees(input, 3, 1) *
      count_trees(input, 5, 1) *
      count_trees(input, 7, 1) *
      count_trees(input, 1, 2)
  end

  def count_trees(input, slope_right, slope_down) do
    max_x = Enum.map(input, fn {{x, _y}, _value} -> x end) |> Enum.max()
    max_y = Enum.map(input, fn {{_x, y}, _value} -> y end) |> Enum.max()
    run(input, {0, 0}, max_x + 1, max_y, slope_right, slope_down, 0)
  end

  def run(_forest, {_x, y}, _max_x, max_y, _slope_right, _slope_down, acc) when y > max_y do
    acc
  end

  def run(forest, {x, y}, max_x, max_y, slope_right, slope_down, acc) do
    run(
      forest,
      {rem(x + slope_right, max_x), y + slope_down},
      max_x,
      max_y,
      slope_right,
      slope_down,
      acc + check_tree({x, y}, forest)
    )
  end

  defp check_tree({x, y}, forest) do
    case forest[{x, y}] do
      :tree -> 1
      :empty -> 0
    end
  end

  def parse_input(file) do
    file
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.map(fn {char, x} -> if char == "#", do: {{x, y}, :tree}, else: {{x, y}, :empty} end)
    end)
    |> Map.new()
  end
end
