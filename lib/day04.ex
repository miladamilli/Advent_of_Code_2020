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
    String.to_integer(byr) in 1920..2002
  end

  defp check(:iyr, iyr) do
    String.to_integer(iyr) in 2010..2020
  end

  defp check(:eyr, eyr) do
    String.to_integer(eyr) in 2020..2030
  end

  defp check(:hgt, hgt) do
    case Integer.parse(hgt) do
      {number, "cm"} -> number in 150..193
      {number, "in"} -> number in 59..76
      _ -> false
    end
  end

  defp check(:hcl, color) do
    Regex.match?(~r/^#[a-f0-9]{6}$/, color)
  end

  @ecl ~w(amb blu brn gry grn hzl oth)
  defp check(:ecl, ecl) do
    ecl in @ecl
  end

  defp check(:pid, pid) do
    Regex.match?(~r/^\d{9}$/, pid)
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
