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
    max_x = Map.keys(input) |> Enum.map(fn {x, _y} -> x end) |> Enum.max()
    max_y = Map.keys(input) |> Enum.map(fn {_x, y} -> y end) |> Enum.max()
    run(input, {0, 0}, max_x, max_y, slope_right, slope_down, 0)
  end

  def run(_forest, {_x, max_y}, _max_x, max_y, _slope_right, _slope_down, acc) do
    acc
  end

  def run(forest, {x, y}, max_x, max_y, slope_right, slope_down, acc) do
    position = check_tree({x + slope_right, y + slope_down}, forest)

    if position == nil do
      run(forest, {x - (max_x + 1), y}, max_x, max_y, slope_right, slope_down, acc)
    else
      run(
        forest,
        {x + slope_right, y + slope_down},
        max_x,
        max_y,
        slope_right,
        slope_down,
        acc + position
      )
    end
  end

  defp check_tree({x, y}, forest) do
    case forest[{x, y}] do
      "tree" -> 1
      "empty" -> 0
      nil -> nil
    end
  end

  def parse_input(file) do
    file
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.map(fn {line, index} ->
      line =
        String.codepoints(line)
        |> Enum.map(fn char ->
          if char == "#", do: "tree", else: "empty"
        end)
        |> Enum.with_index()

      Enum.map(line, fn {field, index_field} -> {{index_field, index}, field} end)
    end)
    |> List.flatten()
    |> Enum.into(%{})
  end
end
