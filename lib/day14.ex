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

  # PART 2 =============================================

  def part2 do
    "input/day14.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> run2(nil, %{})
    |> Map.values()
    |> Enum.sum()
  end

  def run2([], _mask, memory) do
    memory
  end

  def run2([line | rest], mask, memory) do
    case parse_line2(line) do
      {address, value} ->
        run2(rest, mask, update_memory2(mask, address, value, memory))

      mask ->
        run2(rest, mask, memory)
    end
  end

  defp update_memory2(mask, address, value, memory) do
    addresses = apply_mask_on_address(mask, address)

    Enum.reduce(addresses, memory, fn address, mem ->
      Map.put(mem, address, value)
    end)
  end

  defp apply_mask_on_address(mask, address) do
    Enum.zip(address, mask)
    |> Enum.map(fn {val, mask} ->
      case mask do
        0 -> val
        1 -> 1
        :floating -> :floating
      end
    end)
    |> generate_address_variants([[]])
  end

  defp generate_address_variants([], acc) do
    Enum.map(acc, &Enum.reverse/1)
    |> Enum.map(&Integer.undigits(&1, 2))
  end

  defp generate_address_variants([char | rest], acc) do
    acc =
      if char != :floating do
        Enum.map(acc, fn address -> [char | address] end)
      else
        Enum.map(acc, fn address -> [1 | address] end) ++
          Enum.map(acc, fn address ->
            [0 | address]
          end)
      end

    generate_address_variants(rest, acc)
  end

  defp parse_line2("mask = " <> mask) do
    mask
    |> String.codepoints()
    |> Enum.map(fn
      "0" -> 0
      "1" -> 1
      "X" -> :floating
    end)
  end

  defp parse_line2("mem" <> line) do
    [memory_address, value] = String.split(line, " = ")
    address = memory_address |> String.trim_leading("[") |> String.trim_trailing("]")

    address =
      address
      |> String.to_integer()
      |> Integer.digits(2)
      |> Enum.join()
      |> String.pad_leading(36, "0")
      |> String.codepoints()
      |> Enum.map(&String.to_integer/1)

    {address, String.to_integer(value)}
  end
end
