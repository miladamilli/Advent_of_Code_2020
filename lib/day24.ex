defmodule Day24 do
  def part1 do
    parse_input()
    |> flip_tiles
    |> Enum.count(fn {_pos, color} -> color == :black end)
  end

  defp flip_tiles(instructions) do
    Enum.reduce(instructions, %{{0, 0} => :white}, fn tile_instr, tiles ->
      tile_to_flip = flip_one_tile(tile_instr, {0, 0}, tiles)
      Map.update(tiles, tile_to_flip, :black, fn color -> switch_color(color) end)
    end)
  end

  defp flip_one_tile(tile_instructions, position, tiles) do
    case tile_instructions do
      "se" <> tile -> flip_one_tile(tile, update_position(position, "se"), tiles)
      "sw" <> tile -> flip_one_tile(tile, update_position(position, "sw"), tiles)
      "nw" <> tile -> flip_one_tile(tile, update_position(position, "nw"), tiles)
      "ne" <> tile -> flip_one_tile(tile, update_position(position, "ne"), tiles)
      "e" <> tile -> flip_one_tile(tile, update_position(position, "e"), tiles)
      "w" <> tile -> flip_one_tile(tile, update_position(position, "w"), tiles)
      "" -> position
    end
  end

  @coords %{
    "e" => {1, 0},
    "se" => {1, -1},
    "sw" => {0, -1},
    "w" => {-1, 0},
    "nw" => {-1, 1},
    "ne" => {0, 1}
  }
  defp update_position({x, y}, dir) do
    {xx, yy} = @coords[dir]
    {x + xx, y + yy}
  end

  defp switch_color(:black), do: :white
  defp switch_color(:white), do: :black

  def part2 do
    parse_input()
    |> flip_tiles
    |> living_art_exhibit
  end

  defp living_art_exhibit(floor) do
    floor
    |> Stream.iterate(&apply_flipping/1)
    |> Enum.take(101)
    |> Enum.at(-1)
    |> Enum.count(fn {_pos, color} -> color == :black end)
  end

  defp apply_flipping(floor) do
    floor
    |> add_white_around_black()
    |> Enum.reduce(%{}, fn {position, color}, f ->
      black_neighbors_count =
        neighbors(position)
        |> Enum.map(fn pos -> floor[pos] end)
        |> Enum.count(fn color -> color == :black end)

      new_color =
        cond do
          color == :black and (black_neighbors_count == 0 or black_neighbors_count > 2) -> :white
          color == :white and black_neighbors_count == 2 -> :black
          true -> color
        end

      Map.put(f, position, new_color)
    end)
  end

  defp add_white_around_black(floor) do
    blacks =
      Enum.filter(floor, fn {_pos, color} -> color == :black end)
      |> Enum.map(fn {pos, _} -> pos end)

    neighbours = possible_neighbours(blacks, floor)
    new_neighbours = Enum.filter(neighbours, fn {_pos, color} -> color == nil end)
    Enum.reduce(new_neighbours, floor, fn {tile, _}, f -> Map.put(f, tile, :white) end)
  end

  defp possible_neighbours(blacks, floor) do
    Enum.flat_map(blacks, fn tile -> neighbors(tile) |> Enum.map(fn t -> {t, floor[t]} end) end)
  end

  defp neighbors({x, y}) do
    for {nx, ny} <- Map.values(@coords) do
      {x + nx, y + ny}
    end
  end

  defp parse_input() do
    "input/day24.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
