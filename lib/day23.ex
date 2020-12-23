defmodule Day23 do
  @puzzle_input 853_192_647 |> Integer.digits()

  @moves1 100
  def part1 do
    cups = move(@puzzle_input, Enum.min(@puzzle_input), Enum.max(@puzzle_input), @moves1, 0)
    index = Enum.find_index(cups, fn c -> c == 1 end)
    (Enum.slice(cups, (index + 1)..length(cups)) ++ Enum.take(cups, index)) |> Enum.join()
  end

  def move(cups, _min, _max, moves, moves) do
    cups
  end

  def move([current_cup, cup1, cup2, cup3 | cups], min, max, total_moves, moves) do
    dest_cup = destination_cup(current_cup - 1, [cup1, cup2, cup3], min, max)
    new_circle = [current_cup | cups]
    dest_cup_index = Enum.find_index(new_circle, fn c -> c == dest_cup end)

    circle =
      List.insert_at(new_circle, dest_cup_index + 1, [cup1, cup2, cup3])
      |> List.flatten()

    move(tl(circle) ++ [current_cup], min, max, total_moves, moves + 1)
  end

  defp destination_cup(label, selected_cups, label_low, label_high) do
    if label >= label_low do
      if label not in selected_cups do
        label
      else
        destination_cup(label - 1, selected_cups, label_low, label_high)
      end
    else
      destination_cup(label_high, selected_cups, label_low, label_high)
    end
  end

  @many_cups 1_000_000
  @moves2 10_000_000

  def part2() do
    puzzle_input2 = @puzzle_input ++ Enum.to_list(10..@many_cups)

    cup_list =
      tl(puzzle_input2)
      |> Enum.reduce({hd(puzzle_input2), %{@many_cups => hd(puzzle_input2)}}, fn cup,
                                                                                 {prev_cup,
                                                                                  cup_list} ->
        {cup, Map.put(cup_list, prev_cup, cup)}
      end)
      |> elem(1)

    cups =
      move2(
        cup_list,
        hd(puzzle_input2),
        Enum.min(puzzle_input2),
        Enum.max(puzzle_input2),
        @moves2,
        0
      )

    cups[1] * cups[cups[1]]
  end

  def move2(cups, _current_cup, _min, _max, moves, moves) do
    cups
  end

  def move2(cup_list, current_cup, min, max, total_moves, moves) do
    cup1 = cup_list[current_cup]
    cup2 = cup_list[cup1]
    cup3 = cup_list[cup2]
    cup4 = cup_list[cup3]

    dest_cup = destination_cup(current_cup - 1, [cup1, cup2, cup3], min, max)

    cup_list =
      cup_list
      |> Map.put(current_cup, cup4)
      |> Map.put(dest_cup, cup1)
      |> Map.put(cup3, cup_list[dest_cup])

    move2(cup_list, cup4, min, max, total_moves, moves + 1)
  end
end
