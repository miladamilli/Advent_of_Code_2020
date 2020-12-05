defmodule Day05 do
  def part1 do
    "input/day05.txt"
    |> File.read!()
    |> String.split()
    |> Enum.map(&decode/1)
    |> Enum.max()
  end

  def part2 do
    seats =
      "input/day05.txt"
      |> File.read!()
      |> String.split()
      |> Enum.map(&decode/1)
      |> Enum.sort()

    min = Enum.at(seats, 0)
    max = Enum.at(seats, -1)
    [my_seat] = Enum.to_list(min..max) -- seats
    my_seat
  end

  def decode(input) do
    input
    |> String.split_at(7)
    |> decode_seat
  end

  defp decode_seat({row, column}) do
    row = decode_position(String.codepoints(row), 0, 127)
    column = decode_position(String.codepoints(column), 0, 7)
    row * 8 + column
  end

  defp decode_position(seat, min, max) do
    Enum.reduce(seat, {min, max}, fn pos, {min, max} ->
      cond do
        pos in ~w(F L) -> {min, min + div(max - min, 2)}
        pos in ~w(B R) -> {max - div(max - min, 2), max}
      end
    end)
    |> elem(1)
  end
end
