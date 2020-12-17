defmodule Day17 do
  @input "input/day17.txt"
  def part1 do
    run(:dim3)
  end

  def part2 do
    run(:dim4)
  end

  defp run(dimensionsensions) do
    @input
    |> File.read!()
    |> parse(dimensionsensions)
    |> run_cycles(dimensionsensions)
  end

  def run_cycles(grid, dimensions) do
    grid
    |> Stream.iterate(fn original_grid ->
      add_around(dimensions, original_grid)
      |> Enum.reduce(%{}, fn {coord, state}, final_grid ->
        new_state = update_state(dimensions, coord, state, original_grid)
        Map.put(final_grid, coord, new_state)
      end)
    end)
    |> Enum.take(7)
    |> Enum.at(-1)
    |> Map.values()
    |> Enum.filter(fn value -> value == "#" end)
    |> length()
  end

  defp update_state(dimensions, coord, state, orig_grid) do
    neighbors =
      neighbors(dimensions, coord)
      |> Enum.map(fn coord -> orig_grid[coord] end)
      |> Enum.filter(fn state -> state == "#" end)

    cond do
      state == "#" && length(neighbors) in [2, 3] -> "#"
      state == "." && length(neighbors) == 3 -> "#"
      true -> "."
    end
  end

  defp neighbors(:dim3, {x, y, z}) do
    for nx <- -1..1, ny <- -1..1, nz <- -1..1, {nx, ny, nz} != {0, 0, 0} do
      {x + nx, y + ny, z + nz}
    end
  end

  defp neighbors(:dim4, {x, y, z, w}) do
    for nx <- -1..1, ny <- -1..1, nz <- -1..1, nw <- -1..1, {nx, ny, nz, nw} != {0, 0, 0, 0} do
      {x + nx, y + ny, z + nz, w + nw}
    end
  end

  defp add_around(dimensions, grid) do
    active = Enum.filter(grid, fn {_k, v} -> v == "#" end) |> Enum.map(fn {k, _} -> k end)
    neighbours = possible_neighbours(dimensions, active, grid)
    new_neighbours = Enum.filter(neighbours, fn {_n, v} -> v == nil end)
    Enum.reduce(new_neighbours, grid, fn {n, _}, g -> Map.put(g, n, ".") end)
  end

  defp possible_neighbours(dimensions, active, grid) do
    Enum.map(active, fn point ->
      neighbors(dimensions, point) |> Enum.map(fn n -> {n, grid[n]} end)
    end)
    |> List.flatten()
  end

  def parse(input, dimensions) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce({%{}, 0}, fn line, {map, line_id} ->
      new_map =
        line
        |> String.codepoints()
        |> Enum.reduce({%{}, 0}, fn l, {line_map, char_id} ->
          {Map.put(line_map, create_point(dimensions, char_id, line_id), l), char_id + 1}
        end)
        |> elem(0)

      {Map.merge(map, new_map), line_id + 1}
    end)
    |> elem(0)
  end

  defp create_point(:dim3, x, y), do: {x, y, 0}
  defp create_point(:dim4, x, y), do: {x, y, 0, 0}
end
