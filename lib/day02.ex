defmodule Day02 do
  def part1 do
    read_input()
    |> Enum.filter(&check_password/1)
    |> Enum.count()
  end

  def check_password({min, max, letter, password}) do
    count =
      String.codepoints(password)
      |> Enum.count(fn char -> char == letter end)

    count in min..max
  end

  def part2 do
    read_input()
    |> Enum.filter(&check_password2/1)
    |> Enum.count()
  end

  def check_password2({first, second, letter, password}) do
    String.at(password, first - 1) == letter != (String.at(password, second - 1) == letter)
  end

  defp read_input() do
    File.read!("input/day02.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ~r/[-: ]/, trim: true))
    |> Enum.map(fn [min, max, letter, password] ->
      {String.to_integer(min), String.to_integer(max), letter, password}
    end)
  end
end
