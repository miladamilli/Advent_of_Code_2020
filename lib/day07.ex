defmodule Day07 do
  def part1 do
    bags =
      "input/day07.txt"
      |> File.read!()
      |> parse_file

    find_bags(bags, ["shiny gold"], []) |> Enum.uniq() |> Enum.count()
  end

  defp find_bags(_bags, [], acc) do
    acc
  end

  defp find_bags(bags, [bag_wanted | rest], acc) do
    bags_found =
      Enum.filter(bags, fn {_outer_bag, inner_bags} ->
        Enum.any?(inner_bags, &String.contains?(&1, bag_wanted))
      end)
      |> Enum.map(fn {outer_bag, _inner_bags} -> String.trim_trailing(outer_bag, " bags") end)

    find_bags(bags, rest ++ bags_found, acc ++ bags_found)
  end

  defp parse_file(file) do
    file
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " contain "))
    |> Enum.map(fn [outer_bag, inner_bags] ->
      inner_bags = String.trim_trailing(inner_bags, ".") |> String.split(", ")
      {outer_bag, inner_bags}
    end)
  end

  def part2 do
    bags =
      "input/day07.txt"
      |> File.read!()
      |> parse_file2

    count_bags_inside("shiny gold", bags)
  end

  defp count_bags_inside(my_bag, bags) do
    new_bags = bags[my_bag]

    if new_bags == nil do
      0
    else
      bags_in_this_one = Enum.map(new_bags, fn {_bag, count} -> count end) |> Enum.sum()

      other_bags =
        Enum.map(new_bags, fn {bag, count} -> count * count_bags_inside(bag, bags) end)
        |> Enum.sum()

      bags_in_this_one + other_bags
    end
  end

  defp parse_file2(file) do
    file
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " contain "))
    |> Enum.map(fn [outer_bag, inner_bags] ->
      inner_bags =
        inner_bags
        |> String.trim_trailing(".")
        |> String.split(", ")
        |> Enum.reject(&String.contains?(&1, "no other bags"))
        |> Enum.map(fn bag ->
          {number, bag} = String.split_at(bag, 1)

          bag =
            bag
            |> String.trim_trailing(" bags")
            |> String.trim_trailing(" bag")
            |> String.trim_leading()

          {bag, String.to_integer(number)}
        end)
        |> Map.new()

      outer_bag =
        outer_bag
        |> String.trim_trailing(" bags")
        |> String.trim_trailing(" bag")

      {outer_bag, inner_bags}
    end)
    |> Map.new()
  end
end
