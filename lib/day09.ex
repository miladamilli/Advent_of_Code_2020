defmodule Day09 do
  def part1 do
    "input/day09.txt"
    |> File.read!()
    |> parse_input
    |> find_invalid_number(25)
  end

  @min_length 2

  def part2 do
    input =
      "input/day09.txt"
      |> File.read!()
      |> parse_input

    invalid_number = find_invalid_number(input, 25)
    find_encryption_weakness(input, invalid_number, @min_length)
  end

  defp find_encryption_weakness(input, number, length) do
    set = Enum.take(input, length)

    cond do
      Enum.sum(set) > number -> find_encryption_weakness(tl(input), number, @min_length)
      Enum.sum(set) < number -> find_encryption_weakness(input, number, length + 1)
      Enum.sum(set) == number -> Enum.min(set) + Enum.max(set)
    end
  end

  def find_invalid_number(input, length) do
    result = check(input, length)

    if result == true do
      find_invalid_number(tl(input), length)
    else
      result
    end
  end

  defp check(input, length) do
    {preamble, rest} = Enum.split(input, length)
    number = hd(rest)

    result =
      for n1 <- preamble, n2 <- preamble, n1 + n2 == number, n1 != n2 do
        number
      end

    if result != [] do
      true
    else
      number
    end
  end

  def parse_input(file) do
    file
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
