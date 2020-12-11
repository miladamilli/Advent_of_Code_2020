defmodule Day10 do
  def part1 do
    "input/day10.txt"
    |> File.read!()
    |> parse_input
    |> run()
  end

  def part2 do
    "input/day10.txt"
    |> File.read!()
    |> parse_input
    |> run2()
  end

  def run2(adapters) do
    device = Enum.max(adapters) + 3
    adapters = adapters ++ [device]
    count_arrangements(adapters, 0)
  end

  defp count_arrangements([a1, a2, a3 | adapters], outlet) do
    if is_nil(Process.get(outlet)) do
      aa1 = if (a1 - outlet) in 1..3, do: count_arrangements([a2, a3 | adapters], a1), else: 0
      aa2 = if (a2 - outlet) in 1..3, do: count_arrangements([a3 | adapters], a2), else: 0
      aa3 = if (a3 - outlet) in 1..3, do: count_arrangements(adapters, a3), else: 0
      sum = aa1 + aa2 + aa3
      Process.put(outlet, sum)
      sum
    else
      Process.get(outlet)
    end
  end

  defp count_arrangements([_a1, _a2], _outlet) do
    1
  end

  def run(adapters) do
    charging_outlet = 0
    device = Enum.max(adapters) + 3
    test_adapters(adapters ++ [device], charging_outlet, %{1 => 0, 2 => 0, 3 => 0})
  end

  defp test_adapters([], _, differences) do
    differences[1] * differences[3]
  end

  defp test_adapters([adapter | adapters], outlet, differences) do
    diff = adapter - outlet

    if diff in 1..3 do
      test_adapters(adapters, adapter, Map.update!(differences, diff, &(&1 + 1)))
    else
      test_adapters(adapters, outlet, differences)
    end
  end

  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort()
  end
end
