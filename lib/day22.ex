defmodule Day22 do
  def part1 do
    [player1, player2] = parse()
    play(player1, player2)
  end

  defp play([], player), do: count_score(player)
  defp play(player, []), do: count_score(player)

  defp play([card1 | player1], [card2 | player2]) do
    cond do
      card1 > card2 -> play(player1 ++ [card1, card2], player2)
      card1 < card2 -> play(player1, player2 ++ [card2, card1])
    end
  end

  def part2 do
    [player1, player2] = parse()
    {_player_id, cards} = play2(player1, player2, MapSet.new())
    count_score(cards)
  end

  defp play2([], player2, _), do: {:player2, player2}
  defp play2(player1, [], _), do: {:player1, player1}

  defp play2([c1 | p1] = player1, [c2 | p2] = player2, prev_rounds) do
    if MapSet.member?(prev_rounds, {player1, player2}) do
      {:player1, []}
    else
      rounds = MapSet.put(prev_rounds, {player1, player2})

      case match(player1, player2) do
        {:player1, _cards1} -> play2(p1 ++ [c1, c2], p2, rounds)
        {:player2, _cards2} -> play2(p1, p2 ++ [c2, c1], rounds)
      end
    end
  end

  defp match([card1 | player1], [card2 | player2]) do
    if length(player1) >= card1 and length(player2) >= card2 do
      play2(Enum.take(player1, card1), Enum.take(player2, card2), MapSet.new())
    else
      cond do
        card1 > card2 -> {:player1, []}
        card2 > card1 -> {:player2, []}
      end
    end
  end

  defp count_score(cards) do
    cards
    |> Enum.reverse()
    |> Enum.with_index(1)
    |> Enum.reduce(0, fn {card, index}, acc -> acc + card * index end)
  end

  defp parse() do
    "input/day22.txt"
    |> File.read!()
    |> String.split("\n\n")
    |> Enum.map(fn line ->
      [_player, cards] = String.split(line, ":")
      String.split(cards, "\n", trim: true) |> Enum.map(&String.to_integer/1)
    end)
  end
end
