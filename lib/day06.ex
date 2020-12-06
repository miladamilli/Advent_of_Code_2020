defmodule Day06 do
  def part1 do
    "input/day06.txt"
    |> File.read!()
    |> String.split("\n\n")
    |> Enum.map(&String.split(&1, "\n"))
    |> Enum.map(&count_answers/1)
    |> Enum.sum()
  end

  defp count_answers(group) do
    group
    |> Enum.join()
    |> String.codepoints()
    |> Enum.uniq()
    |> Enum.count()
  end

  def part2 do
    "input/day06.txt"
    |> File.read!()
    |> check_answers()
  end

  def check_answers(answers) do
    answers
    |> String.split("\n\n")
    |> Enum.map(&String.split(&1, "\n", trim: true))
    |> Enum.map(&count_answers2/1)
    |> Enum.sum()
  end

  defp count_answers2(group) do
    answers = group |> Enum.map(&String.codepoints/1)
    all_answers = answers |> List.flatten() |> Enum.uniq()

    Enum.reduce(answers, MapSet.new(all_answers), fn passenger, intersection ->
      MapSet.intersection(MapSet.new(passenger), intersection)
    end)
    |> Enum.count()
  end
end
