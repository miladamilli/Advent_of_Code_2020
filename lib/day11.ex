defmodule Day11 do
  def part1 do
    "input/day11.txt"
    |> File.read!()
    |> run
  end

  def run(input) do
    input
    |> parse_input
    |> run_seats({4, :adjacent})
  end

  def part2 do
    "input/day11.txt"
    |> File.read!()
    |> run2
  end

  def run2(input) do
    input
    |> parse_input
    |> run_seats({5, :first_visible})
  end

  defp run_seats(seats, opts) do
    new_seats =
      Enum.reduce(seats, %{}, fn {seat, value}, map ->
        Map.put(map, seat, check_seat(value, seat, seats, opts))
      end)

    if new_seats != seats do
      run_seats(new_seats, opts)
    else
      Enum.filter(seats, fn {_seat, value} -> value == "#" end)
      |> Enum.count()
    end
  end

  defp check_seat(seat, seat_position, seats, {number_visible, style}) do
    adjacent = adjacent_seats(seat_position, seats, style)

    cond do
      seat == "L" && Enum.all?(adjacent, fn adj -> adj == "L" end) -> "#"
      seat == "#" && length(Enum.filter(adjacent, &(&1 == "#"))) >= number_visible -> "L"
      true -> seat
    end
  end

  defp adjacent_seats(seat_position, seats, style) do
    for x <- -1..1, y <- -1..1, {x, y} != {0, 0} do
      {x, y}
    end
    |> Enum.map(fn seat -> find_visible(seat, seat_position, seats, style) end)
    |> Enum.reject(fn val -> val in [nil, "."] end)
  end

  defp find_visible({x, y}, {seat_pos_x, seat_pos_y}, seats, :adjacent) do
    seats[{seat_pos_x + x, seat_pos_y + y}]
  end

  defp find_visible({x, y}, {seat_pos_x, seat_pos_y} = seat, seats, style) do
    seat_value = seats[{seat_pos_x + x, seat_pos_y + y}]

    if seat_value in [nil, "#", "L"] do
      seat_value
    else
      case {x, y} do
        {nx, 0} ->
          cond do
            nx > 0 -> find_visible({nx + 1, 0}, seat, seats, style)
            nx < 0 -> find_visible({nx - 1, 0}, seat, seats, style)
          end

        {0, ny} ->
          cond do
            ny > 0 -> find_visible({0, ny + 1}, seat, seats, style)
            ny < 0 -> find_visible({0, ny - 1}, seat, seats, style)
          end

        {nx, nx} ->
          cond do
            nx > 0 -> find_visible({nx + 1, nx + 1}, seat, seats, style)
            nx < 0 -> find_visible({nx - 1, nx - 1}, seat, seats, style)
          end

        {nx, ny} ->
          cond do
            nx < 0 -> find_visible({nx - 1, ny + 1}, seat, seats, style)
            ny < 0 -> find_visible({nx + 1, ny - 1}, seat, seats, style)
          end
      end
    end
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce({%{}, 0}, fn line, {map, line_id} ->
      {new_map, _new_id} =
        Enum.reduce(String.codepoints(line), {%{}, 0}, fn l, {line_map, char_id} ->
          {Map.put(line_map, {char_id, line_id}, l), char_id + 1}
        end)

      {Map.merge(map, new_map), line_id + 1}
    end)
    |> elem(0)
  end
end
