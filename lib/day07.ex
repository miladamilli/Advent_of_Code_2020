defmodule Day07 do
  def part1 do
    "input/day07.txt"
    |> File.read!()
    |> parse_file
    |> find_bags(["shiny gold"], [])
    |> Enum.uniq()
    |> Enum.count()
  end

  defp find_bags(_bags, [], acc) do
    acc
  end

  defp find_bags(bags, [bag_wanted | rest], acc) do
    bags_found =
      Enum.filter(bags, fn {_outer_bag, inner_bags} ->
        Enum.any?(inner_bags, &String.contains?(&1, bag_wanted))
      end)
      |> Enum.map(fn {outer_bag, _inner_bags} -> trim(outer_bag) end)

    find_bags(bags, rest ++ bags_found, acc ++ bags_found)
  end

  defp parse_file(file) do
    file
    |> String.split("\n", trim: true)
    |> Enum.map(&String.trim_trailing(&1, "."))
    |> Enum.map(&String.split(&1, " contain "))
    |> Enum.map(fn [outer_bag, inner_bags] -> {outer_bag, String.split(inner_bags, ", ")} end)
  end

  def part2 do
    "input/day07.txt"
    |> File.read!()
    |> parse_file
    |> parse_data
    |> count_bags_inside("shiny gold")
  end

  defp count_bags_inside(bags, my_bag) do
    new_bags = bags[my_bag]

    if new_bags != nil do
      bags_in_this_one = Enum.map(new_bags, fn {_bag, count} -> count end) |> Enum.sum()

      other_bags =
        new_bags
        |> Enum.map(fn {bag, count} -> count * count_bags_inside(bags, bag) end)
        |> Enum.sum()

      bags_in_this_one + other_bags
    else
      0
    end
  end

  defp parse_data(inner_bags) do
    inner_bags
    |> Enum.map(fn {outer_bag, inner_bags} ->
      inner_bags =
        inner_bags
        |> Enum.reject(&String.contains?(&1, "no other bags"))
        |> Enum.map(fn bag ->
          {number, bag} = String.split_at(bag, 1)
          bag = trim(bag)
          {bag, String.to_integer(number)}
        end)
        |> Map.new()

      {trim(outer_bag), inner_bags}
    end)
    |> Map.new()
  end

  defp trim(line) do
    line
    |> String.trim_trailing("bags")
    |> String.trim_trailing("bag")
    |> String.trim()
  end
end
