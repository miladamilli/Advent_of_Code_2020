defmodule Day14 do
  def part1 do
    "input/day14.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.chunk_by(fn line -> String.contains?(line, "mask") end)
    |> run(%{})
    |> Map.values()
    |> Enum.sum()
  end

  def run([], memory) do
    memory
  end

  def run([mask, mems | rest], memory) do
    mask = read_mask(mask)
    new_memory = write_values(mask, mems, memory)
    run(rest, new_memory)
  end

  defp write_values(mask, mems, memory) do
    to_write = Enum.map(mems, &read_mem/1)

    Enum.reduce(to_write, memory, fn {address, value}, mem ->
      new_value = apply_mask(mask, value)

      Map.put(mem, address, Integer.undigits(new_value, 2))
    end)
  end

  defp apply_mask(mask, value) do
    value =
      value
      |> Integer.digits(2)
      |> Enum.join()
      |> String.pad_leading(36, "0")
      |> String.codepoints()
      |> Enum.map(&String.to_integer/1)

    mask =
      String.codepoints(mask)
      |> Enum.map(fn char ->
        case char do
          "X" -> :x
          "0" -> 0
          "1" -> 1
        end
      end)

    Enum.zip(value, mask)
    |> Enum.map(fn {val, mask} -> if mask == :x, do: val, else: mask end)
  end

  defp read_mask([mask]) do
    [_, mask] = String.split(mask, " = ")
    mask
  end

  defp read_mem(mem) do
    [memory_address, value] = String.split(mem, " = ")
    [[address]] = Regex.scan(~r/\d+/, memory_address)
    {address, String.to_integer(value)}
  end
end
