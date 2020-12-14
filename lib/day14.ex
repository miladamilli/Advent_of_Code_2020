defmodule Day14 do
  def part1 do
    "input/day14.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> run(nil, %{})
    |> Map.values()
    |> Enum.sum()
  end

  def run([], _mask, memory) do
    memory
  end

  def run([line | rest], mask, memory) do
    case parse_line(line) do
      {address, value} ->
        run(rest, mask, update_memory(mask, address, value, memory))

      mask ->
        run(rest, mask, memory)
    end
  end

  defp parse_line("mask = " <> mask) do
    mask
    |> String.codepoints()
    |> Enum.map(fn
      "X" -> :x
      "0" -> 0
      "1" -> 1
    end)
  end

  defp parse_line("mem" <> line) do
    [memory_address, value] = String.split(line, " = ")
    address = memory_address |> String.trim_leading("[") |> String.trim_trailing("]")

    value =
      value
      |> String.to_integer()
      |> Integer.digits(2)
      |> Enum.join()
      |> String.pad_leading(36, "0")
      |> String.codepoints()
      |> Enum.map(&String.to_integer/1)

    {address, value}
  end

  defp update_memory(mask, address, value, memory) do
    new_value = apply_mask(mask, value) |> Integer.undigits(2)
    Map.put(memory, address, new_value)
  end

  defp apply_mask(mask, value) do
    Enum.zip(value, mask)
    |> Enum.map(fn {val, mask} -> if mask == :x, do: val, else: mask end)
  end
end
