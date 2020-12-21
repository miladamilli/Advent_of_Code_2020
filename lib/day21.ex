defmodule Day21 do
  def part1 do
    food_list = parse_input()
    all_ingredients = Enum.map(food_list, fn {ingr, _} -> ingr end) |> List.flatten()
    allergens_map = allergens_map(food_list, all_ingredients)
    ingredients_with_allergens = Map.values(allergens_map)

    all_ingredients
    |> Enum.reject(fn i -> i in ingredients_with_allergens end)
    |> Enum.count()
  end

  def part2() do
    food_list = parse_input()
    all_ingredients = Enum.map(food_list, fn {ingr, _} -> ingr end) |> List.flatten()

    allergens_map(food_list, all_ingredients)
    |> Enum.sort_by(fn {allerg, _i} -> allerg end)
    |> Enum.map(fn {_a, ingr} -> ingr end)
    |> Enum.join(",")
  end

  def allergens_map(food, all_ingredients) do
    ingredients_unique = Enum.uniq(all_ingredients)
    allergens = Enum.map(food, fn {_, aller} -> aller end) |> List.flatten() |> Enum.uniq()
    detect_allergens(allergens, ingredients_unique, food)
  end

  defp detect_allergens(allergens, ingredients, food) do
    Enum.map(allergens, fn allerg ->
      foods_with_this_allerg =
        Enum.filter(food, fn {_i, a} -> allerg in a end)
        |> Enum.map(fn {i, _} -> i end)

      possible_ingredients_with_this_alerg =
        Enum.filter(ingredients, fn i ->
          Enum.all?(foods_with_this_allerg, fn f -> i in f end)
        end)

      {allerg, possible_ingredients_with_this_alerg}
    end)
    |> identify_unique(%{})
  end

  defp identify_unique([], result) do
    result
  end

  defp identify_unique(allergens, result) do
    {allerg, [food]} = Enum.find(allergens, fn {_a, i} -> length(i) == 1 end)

    remaining =
      Enum.map(allergens, fn {a, f} -> {a, f -- [food]} end)
      |> Enum.reject(fn {_a, f} -> f == [] end)

    identify_unique(remaining, Map.put(result, allerg, food))
  end

  defp parse_input() do
    "input/day21.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [ingredients, allergens] = String.split(line, "(")

      allergens =
        allergens
        |> String.trim_leading("contains ")
        |> String.trim_trailing(")")
        |> String.split(", ")

      ingredients = String.split(ingredients, " ", trim: true)
      {ingredients, allergens}
    end)
  end
end
