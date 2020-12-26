defmodule Day19 do
  def part1 do
    {rules, messages} = parse_input()
    Enum.count(messages, fn message -> run(message, rules["0"], rules) == true end)
  end

  @new_rules """
  8: 42 | 42 8
  11: 42 31 | 42 11 31
  """
  def part2 do
    {rules, messages} = parse_input()
    new_rules = parse_rules(@new_rules)
    rules = Map.merge(rules, new_rules)
    Enum.count(messages, fn message -> run(message, rules["0"], rules) end)
  end

  defp run("", [], _rules_map) do
    true
  end

  defp run(_, [], _rules_map) do
    false
  end

  defp run(message, [rule | rules], rules_map) do
    {letter, message_rest} = String.split_at(message, 1)

    case rule do
      rule when rule in ["a", "b"] ->
        if rule == letter, do: run(message_rest, rules, rules_map), else: false

      [rule] ->
        run(message, [rules_map[rule] | rules], rules_map)

      [rule1, rule2] ->
        run(message, [rules_map[rule1], rule2 | rules], rules_map)

      [rule1, rule2, rule3] ->
        run(message, [rules_map[rule1], rule2, rule3 | rules], rules_map)

      {rule1, rule2} ->
        run(message, [rule1 | rules], rules_map) or
          run(message, [rule2 | rules], rules_map)

      rule ->
        run(message, [rules_map[rule] | rules], rules_map)
    end
  end

  defp parse_rules(rules) do
    rules
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn x, map ->
      [id, list] = String.split(x, ": ")

      list = String.split(list, " | ")

      case list do
        [rule1, rule2] ->
          Map.put(map, id, {String.split(rule1, " "), String.split(rule2, " ")})

        [list] ->
          if String.contains?(list, "a") or String.contains?(list, "b") do
            Map.put(map, id, String.replace(list, "\"", ""))
          else
            Map.put(map, id, String.split(list, " "))
          end
      end
    end)
  end

  defp parse_input() do
    [rules, messages] = "input/day19.txt" |> File.read!() |> String.split("\n\n")
    {parse_rules(rules), String.split(messages, "\n")}
  end
end
