defmodule Day15 do
  @puzzle_input [19, 0, 5, 1, 10, 13]

  @turns_part1 2020
  def part1 do
    run(@puzzle_input, @turns_part1)
  end

  @turns_part2 30_000_000
  def part2 do
    run(@puzzle_input, @turns_part2)
  end

  defp run(puzzle_input, turns) do
    puzzle_input
    |> Enum.with_index(1)
    |> List.delete_at(-1)
    |> Map.new()
    |> play(Enum.at(puzzle_input, -1), turns, length(puzzle_input))
  end

  defp play(_acc, recent_number, final_turn, final_turn) do
    recent_number
  end

  defp play(acc, recent_number, final_turn, turns) do
    new_number =
      case acc[recent_number] do
        nil -> 0
        prev_turn -> turns - prev_turn
      end

    play(Map.put(acc, recent_number, turns), new_number, final_turn, turns + 1)
  end
end
