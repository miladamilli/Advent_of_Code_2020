defmodule Day08 do
  def part1 do
    "input/day08.txt"
    |> parse_file
    |> run1(0, MapSet.new(), 0)
  end

  defp run1(input, position, visited, acc) do
    {op, value} = input[position]

    if not MapSet.member?(visited, position) do
      case op do
        "acc" -> run1(input, position + 1, MapSet.put(visited, position), acc + value)
        "jmp" -> run1(input, position + value, MapSet.put(visited, position), acc)
        "nop" -> run1(input, position + 1, MapSet.put(visited, position), acc)
      end
    else
      acc
    end
  end

  def part2 do
    "input/day08.txt"
    |> parse_file
    |> repair_program(0)
  end

  defp repair_program(input, position) do
    {op, value} = input[position]

    result =
      case op do
        "acc" -> repair_program(input, position + 1)
        "jmp" -> run2(Map.put(input, position, {switch_op(op), value}), 0, MapSet.new(), 0)
        "nop" -> run2(Map.put(input, position, {switch_op(op), value}), 0, MapSet.new(), 0)
      end

    if result == :loop do
      repair_program(input, position + 1)
    else
      result
    end
  end

  defp switch_op("jmp"), do: "nop"
  defp switch_op("nop"), do: "jmp"

  defp run2(input, position, visited, acc) do
    if input[position] != nil do
      {op, value} = input[position]

      if not MapSet.member?(visited, position) do
        case op do
          "acc" -> run2(input, position + 1, MapSet.put(visited, position), acc + value)
          "jmp" -> run2(input, position + value, MapSet.put(visited, position), acc)
          "nop" -> run2(input, position + 1, MapSet.put(visited, position), acc)
        end
      else
        :loop
      end
    else
      acc
    end
  end

  defp parse_file(file) do
    file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
    |> Enum.with_index()
    |> Enum.map(fn {[op, value], index} -> {index, {op, String.to_integer(value)}} end)
    |> Map.new()
  end
end
