defmodule Day17 do
  def part1 do
    "input/day17.txt"
    |> File.read!()
    |> parse
    |> run
  end

  def run(grid) do
    grid
    |> Stream.iterate(fn original_grid ->
      Enum.reduce(add_around(original_grid), %{}, fn {coord, state}, final_grid ->
        update_state(coord, state, final_grid, original_grid)
      end)
    end)
    |> Enum.take(7)
    |> Enum.at(-1)
    |> Map.values()
    |> Enum.filter(fn value -> value == "#" end)
    |> length()
  end

  defp update_state(coord, state, grid, orig_grid) do
    neighbors = neighbors(coord, orig_grid)

    new_state =
      cond do
        state == "#" && length(neighbors) in [2, 3] -> "#"
        state == "." && length(neighbors) == 3 -> "#"
        true -> "."
      end

    Map.put(grid, coord, new_state)
  end

  defp add_around(grid) do
    active = Enum.filter(grid, fn {_k, v} -> v == "#" end) |> Enum.map(fn {k, _} -> k end)

    neighbours =
      for {x, y, z} <- active do
        for nx <- -1..1, ny <- -1..1, nz <- -1..1, {nx, ny, nz} != {0, 0, 0} do
          n = {x + nx, y + ny, z + nz}
          {n, grid[n]}
        end
      end
      |> List.flatten()

    nn = Enum.filter(neighbours, fn {_n, v} -> v == nil end)
    Enum.reduce(nn, grid, fn {n, _}, g -> Map.put(g, n, ".") end)
  end

  defp neighbors({x, y, z}, grid) do
    for nx <- -1..1, ny <- -1..1, nz <- -1..1, {nx, ny, nz} != {0, 0, 0} do
      {x + nx, y + ny, z + nz}
    end
    |> Enum.map(fn coord -> grid[coord] end)
    |> Enum.filter(fn state -> state == "#" end)
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce({%{}, 0}, fn line, {map, line_id} ->
      {new_map, _new_id} =
        Enum.reduce(String.codepoints(line), {%{}, 0}, fn l, {line_map, char_id} ->
          {Map.put(line_map, {char_id, line_id, 0}, l), char_id + 1}
        end)

      {Map.merge(map, new_map), line_id + 1}
    end)
    |> elem(0)
  end

  # PART 2 ===========================================

  def part2 do
    "input/day17.txt"
    |> File.read!()
    |> parse2
    |> run2
  end

  def run2(grid) do
    grid
    |> Stream.iterate(fn original_grid ->
      Enum.reduce(add_around2(original_grid), %{}, fn {coord, state}, final_grid ->
        update_state2(coord, state, final_grid, original_grid)
      end)
    end)
    |> Enum.take(7)
    |> Enum.at(-1)
    |> Map.values()
    |> Enum.filter(fn value -> value == "#" end)
    |> length()
  end

  defp update_state2(coord, state, grid, orig_grid) do
    neighbors = neighbors2(coord, orig_grid)

    new_state =
      cond do
        state == "#" && length(neighbors) in [2, 3] -> "#"
        state == "." && length(neighbors) == 3 -> "#"
        true -> "."
      end

    Map.put(grid, coord, new_state)
  end

  defp add_around2(grid) do
    active = Enum.filter(grid, fn {_k, v} -> v == "#" end) |> Enum.map(fn {k, _} -> k end)

    neighbours =
      for {x, y, z, w} <- active do
        for nx <- -1..1,
            ny <- -1..1,
            nz <- -1..1,
            nw <- -1..1,
            {nx, ny, nz, nw} != {0, 0, 0, 0} do
          n = {x + nx, y + ny, z + nz, w + nw}
          {n, grid[n]}
        end
      end
      |> List.flatten()

    nn = Enum.filter(neighbours, fn {_n, v} -> v == nil end)
    Enum.reduce(nn, grid, fn {n, _}, g -> Map.put(g, n, ".") end)
  end

  defp neighbors2({x, y, z, w}, grid) do
    for nx <- -1..1, ny <- -1..1, nz <- -1..1, nw <- -1..1, {nx, ny, nz, nw} != {0, 0, 0, 0} do
      {x + nx, y + ny, z + nz, w + nw}
    end
    |> Enum.map(fn coord -> grid[coord] end)
    |> Enum.filter(fn state -> state == "#" end)
  end

  def parse2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce({%{}, 0}, fn line, {map, line_id} ->
      {new_map, _new_id} =
        Enum.reduce(String.codepoints(line), {%{}, 0}, fn l, {line_map, char_id} ->
          {Map.put(line_map, {char_id, line_id, 0, 0}, l), char_id + 1}
        end)

      {Map.merge(map, new_map), line_id + 1}
    end)
    |> elem(0)
  end
end
