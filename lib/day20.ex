defmodule Day20 do
  @sea_monster """
                    #
  #    ##    ##    ###
   #  #  #  #  #  #
  """

  def part1 do
    "input/day20.txt"
    |> File.read!()
    |> parse_input()
    |> find_corner_tiles
    |> Enum.reduce(1, fn k, acc -> k * acc end)
  end

  def part2 do
    "input/day20.txt"
    |> File.read!()
    |> run()
  end

  def run(input) do
    tiles = parse_input(input)
    first_corner_tile_id = Enum.random(find_corner_tiles(tiles))
    rest_of_tiles = Map.delete(tiles, first_corner_tile_id) |> Enum.map(fn {_id, v} -> v end)

    first_tile_rotated = rotate_first_tile(tiles[first_corner_tile_id], rest_of_tiles)
    board_with_first_tile_rotated = %{{0, 0} => first_tile_rotated}

    completed_board =
      place_and_rotate_tiles(rest_of_tiles, board_with_first_tile_rotated)
      |> cut_borders
      |> join_map
      |> Enum.filter(fn {_pos, char} -> char == "#" end)
      |> Map.new()

    sea_monster =
      @sea_monster
      |> String.split("\n")
      |> image_to_map()
      |> Enum.filter(fn {_pos, char} -> char == "#" end)
      |> Map.new()

    find_sea_monster(sea_monster, completed_board, 0)
    |> Enum.count(fn {_, char} -> char == "#" end)
  end

  defp rotate_first_tile(first_tile, tiles) do
    tile_borders = list_borders(first_tile)

    rest_borders =
      Enum.reduce(tiles, [], fn t, acc ->
        b = list_borders(t)
        b ++ Enum.map(b, &Enum.reverse/1) ++ acc
      end)

    borders_to_connect = Enum.filter(tile_borders, fn b -> b in rest_borders end)
    borders_to_connect = borders_to_connect ++ Enum.map(borders_to_connect, &Enum.reverse/1)
    rotate_first_tile(first_tile, borders_to_connect, rest_borders, 0)
  end

  defp rotate_first_tile(tile, borders_to_connect, rest_borders, count) do
    if border_right(tile) in borders_to_connect and border_top(tile) in borders_to_connect do
      tile
    else
      if count < 3 do
        rotate_first_tile(rotate(tile), borders_to_connect, rest_borders, count + 1)
      else
        rotate_first_tile(flip(tile), borders_to_connect, rest_borders, 0)
      end
    end
  end

  defp find_sea_monster(monster, map, count) do
    max = Enum.map(map, fn {{x, _y}, _} -> x end) |> Enum.max()
    possible_shifts = for x <- 0..max, y <- 0..max, do: {x, y}

    shifts =
      Enum.filter(possible_shifts, fn {x, y} ->
        Enum.all?(monster, fn {{mx, my}, _m} -> map[{mx + x, my + y}] == "#" end)
      end)

    if shifts != [] do
      Enum.reduce(shifts, map, fn {x, y}, m ->
        Enum.reduce(monster, m, fn {{mx, my}, _m}, mon -> Map.delete(mon, {mx + x, my + y}) end)
      end)
    else
      if count < 3 do
        find_sea_monster(monster, rotate(map), count + 1)
      else
        find_sea_monster(monster, flip(map), 0)
      end
    end
  end

  defp join_map(map) do
    {max, _} = Map.values(map) |> hd |> Enum.map(fn {x, _y} -> x end) |> Enum.max()
    {min, _} = Map.values(map) |> hd |> Enum.map(fn {x, _y} -> x end) |> Enum.min()
    size = max - min + 1

    Enum.reduce(map, %{}, fn {{x, y}, points}, m ->
      Enum.reduce(points, m, fn {{px, py}, point}, mm ->
        Map.put(mm, {px + x * size, py + y * size}, point)
      end)
    end)
  end

  defp cut_borders(map) do
    Enum.map(map, fn {pos, image} ->
      max = Enum.map(image, fn {{x, _}, _} -> x end) |> Enum.max()
      min = Enum.map(image, fn {{x, _}, _} -> x end) |> Enum.min()

      image =
        Enum.reject(image, fn {{x, y}, _} -> x in [min, max] or y in [min, max] end)
        |> Map.new()

      {pos, image}
    end)
    |> Map.new()
  end

  defp border_right(image), do: border(image, &extract_x/1, &Enum.max/1)
  defp border_left(image), do: border(image, &extract_x/1, &Enum.min/1)
  defp border_top(image), do: border(image, &extract_y/1, &Enum.max/1)
  defp border_bottom(image), do: border(image, &extract_y/1, &Enum.min/1)

  defp extract_x({{x, _}, _}), do: x
  defp extract_y({{_, y}, _}), do: y

  defp border(image, extr, min_max) do
    m = Enum.map(image, extr) |> min_max.()

    image
    |> Enum.filter(fn p -> extr.(p) == m end)
    |> Enum.sort()
    |> Enum.map(fn {_, char} -> char end)
  end

  defp rotate(image) do
    min = Map.keys(image) |> Enum.map(fn {x, _y} -> x end) |> Enum.min()
    max = Map.keys(image) |> Enum.map(fn {x, _y} -> x end) |> Enum.max()
    Enum.reduce(image, %{}, fn {{x, y}, char}, m -> Map.put(m, {y, max - x + min}, char) end)
  end

  defp flip(image) do
    min = Map.keys(image) |> Enum.map(fn {x, _y} -> x end) |> Enum.min()
    max = Map.keys(image) |> Enum.map(fn {x, _y} -> x end) |> Enum.max()
    Enum.reduce(image, %{}, fn {{x, y}, char}, m -> Map.put(m, {max - x + min, y}, char) end)
  end

  defp image_to_map(image) do
    Enum.reduce(image, {%{}, 0}, fn line, {map, line_id} ->
      new_map =
        line
        |> String.codepoints()
        |> Enum.reduce({map, 0}, fn char, {line_map, char_id} ->
          {Map.put(line_map, {char_id, line_id}, char), char_id + 1}
        end)
        |> elem(0)

      {new_map, line_id + 1}
    end)
    |> elem(0)
  end

  defp place_and_rotate_tiles([], board) do
    board
  end

  defp place_and_rotate_tiles([image | rest_tiles], board) do
    neighb = placed_neighbours(image, board)

    if neighb != [] do
      {{x, y}, rotated_image} = hd(neighb)
      orig_image = board[{x, y}]

      pos =
        cond do
          border_right(orig_image) == border_left(rotated_image) -> {x + 1, y}
          border_top(orig_image) == border_bottom(rotated_image) -> {x, y + 1}
        end

      final_board = Map.put(board, pos, rotated_image)
      place_and_rotate_tiles(rest_tiles, final_board)
    else
      place_and_rotate_tiles(rest_tiles ++ [image], board)
    end
  end

  defp placed_neighbours(image, board) do
    image_variants = image_variants(image)

    Enum.map(board, fn {pos, im} ->
      ims =
        Enum.find(image_variants, fn i ->
          border_right(im) == border_left(i) or
            border_top(im) == border_bottom(i)
        end)

      {pos, ims}
    end)
    |> Enum.filter(fn {_pos, im} -> im != nil end)
  end

  defp image_variants(image) do
    [
      image,
      rotate(image),
      rotate(rotate(image)),
      rotate(rotate(rotate(image))),
      flip(image),
      rotate(flip(image)),
      rotate(rotate(flip(image))),
      rotate(rotate(rotate(flip(image))))
    ]
  end

  defp find_corner_tiles(tiles) do
    Enum.filter(tiles, fn {id, tile} -> borders_match(tile, Map.delete(tiles, id)) == 2 end)
    |> Map.new()
    |> Map.keys()
  end

  defp list_borders(tile) do
    [border_left(tile), border_right(tile), border_top(tile), border_bottom(tile)]
  end

  defp borders_match(tile, tiles) do
    borders = list_borders(tile)
    borders = borders ++ Enum.map(borders, fn x -> Enum.reverse(x) end)
    Enum.count(tiles, fn {_id, t} -> Enum.any?(list_borders(t), fn b -> b in borders end) end)
  end

  def parse_input(file) do
    file
    |> String.split("\n\n")
    |> Enum.map(fn tile ->
      tile = String.split(tile, "\n", trim: true)
      {parse_tile_name(tile), tl(tile) |> image_to_map}
    end)
    |> Map.new()
  end

  defp parse_tile_name([tile_name | _tile]) do
    Regex.run(~r/\d+/, tile_name)
    |> hd
    |> String.to_integer()
  end
end
