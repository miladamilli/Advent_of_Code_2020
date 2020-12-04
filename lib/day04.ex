defmodule Day04 do
  def part1 do
    read_input(File.read!("input/day04.txt"))
    |> Enum.count(&check_passport/1)
  end

  defp check_passport(passport) do
    cond do
      length(passport) == 8 -> true
      length(passport) < 7 -> false
      true -> not Enum.any?(passport, fn [field, _] -> field == "cid" end)
    end
  end

  def part2 do
    read_input(File.read!("input/day04.txt"))
    |> Enum.count(&check_passport2/1)
  end

  def check_passport2(passport) do
    if check_all_fields_present(passport) do
      Enum.all?(passport, fn [field, value] -> check(String.to_atom(field), value) end)
    else
      false
    end
  end

  @required_fields ~w(byr iyr eyr hgt hcl ecl pid)

  defp check_all_fields_present(passport) do
    fields_present = Enum.map(passport, fn [field, _value] -> field end)
    Enum.all?(@required_fields, fn field -> field in fields_present end)
  end

  defp check(:byr, byr) do
    byr = String.to_integer(byr)
    byr >= 1920 && byr <= 2002
  end

  defp check(:iyr, iyr) do
    byr = String.to_integer(iyr)
    byr >= 2010 && byr <= 2020
  end

  defp check(:eyr, eyr) do
    byr = String.to_integer(eyr)
    byr >= 2020 && byr <= 2030
  end

  defp check(:hgt, hgt) do
    case Integer.parse(hgt) do
      {number, "cm"} -> number >= 150 && number <= 193
      {number, "in"} -> number >= 59 && number <= 76
      _ -> false
    end
  end

  @color ~w(a b c d e f 0 1 2 3 4 5 6 7 8 9)
  defp check(:hcl, "#" <> color) do
    if byte_size(color) != 6 do
      false
    else
      color = String.codepoints(color)
      Enum.all?(color, fn char -> char in @color end)
    end
  end

  defp check(:hcl, _hcl) do
    false
  end

  @ecl ~w(amb blu brn gry grn hzl oth)
  defp check(:ecl, ecl) do
    ecl in @ecl
  end

  @digits ~w(0 1 2 3 4 5 6 7 8 9)

  defp check(:pid, pid) do
    if byte_size(pid) != 9 do
      false
    else
      pid = String.codepoints(pid)
      Enum.all?(pid, fn char -> char in @digits end)
    end
  end

  defp check(:cid, _cid) do
    true
  end

  def read_input(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.split(&1, ["\n", " "], trim: true))
    |> Enum.map(&Enum.map(&1, fn item -> String.split(item, ":") end))
  end
end
