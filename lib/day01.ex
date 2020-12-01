defmodule Day01 do
  alias Input

  def part1 do
    data = Input.file_numbers("day01")

    for a <- data, b <- data, a + b == 2020 do
      a * b
    end
    |> hd()
  end

  def part2 do
    data = Input.file_numbers("day01")

    for a <- data, b <- data, c <- data, a + b + c == 2020 do
      a * b * c
    end
    |> hd()
  end
end
