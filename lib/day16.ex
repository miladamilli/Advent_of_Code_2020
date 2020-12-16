defmodule Day16 do
  def part1 do
    {rules, _my_ticket, nearby_tickets} = parse("input/day16.txt")
    invalid_tickets_error_rate(nearby_tickets, rules)
  end

  @fields_count 20
  def part2 do
    {rules, my_ticket, nearby_tickets} = parse("input/day16.txt")
    valid_tickets = Enum.filter(nearby_tickets, fn ticket -> ticket_valid?(ticket, rules) end)

    potential_fields =
      Enum.map(rules, fn {name, range1, range2} ->
        {name, range1, range2, Enum.to_list(0..(@fields_count - 1))}
      end)

    valid_tickets
    |> determine_fields(potential_fields)
    |> final_fields(%{})
    |> Enum.filter(fn {_pos, name} -> String.contains?(name, "departure") end)
    |> Enum.map(fn {pos, _name} -> pos end)
    |> Enum.reduce(1, fn pos, acc -> Enum.at(my_ticket, pos) * acc end)
  end

  defp final_fields([], final_fields) do
    final_fields
  end

  defp final_fields(fields, final_fields) do
    {name, [position]} = Enum.find(fields, fn {_name, positions} -> length(positions) == 1 end)

    fields
    |> Enum.map(fn {name, positions} -> {name, positions -- [position]} end)
    |> Enum.reject(fn {_n, positions} -> positions == [] end)
    |> final_fields(Map.put(final_fields, position, name))
  end

  defp determine_fields([], final_fields) do
    Enum.map(final_fields, fn {name, _, _, positions} -> {name, positions} end)
  end

  defp determine_fields([ticket | tickets], final_fields) do
    final_fields =
      Enum.map(final_fields, fn {name, range1, range2, ids} ->
        ids =
          Enum.filter(ids, fn id ->
            Enum.member?(range1, Enum.at(ticket, id)) or Enum.member?(range2, Enum.at(ticket, id))
          end)

        {name, range1, range2, ids}
      end)

    determine_fields(tickets, final_fields)
  end

  defp ticket_valid?(ticket, rules) do
    Enum.all?(ticket, fn value -> value_valid?(value, rules) end)
  end

  defp value_valid?(value, rules) do
    Enum.any?(rules, fn {_rule, range1, range2} ->
      Enum.member?(range1, value) or Enum.member?(range2, value)
    end)
  end

  defp invalid_tickets_error_rate(tickets, rules) do
    Enum.reduce(tickets, 0, fn ticket, error_rate ->
      errors = Enum.filter(ticket, fn value -> not value_valid?(value, rules) end)
      error_rate + Enum.sum(errors)
    end)
  end

  defp parse(file) do
    [rules, my_ticket, nearby_tickets] =
      file
      |> File.read!()
      |> String.split(["your ticket:", "nearby tickets:"], trim: true)
      |> Enum.map(&String.split(&1, "\n", trim: true))

    {parse_rules(rules), parse_my_ticket(my_ticket), parse_nearby_tickets(nearby_tickets)}
  end

  defp parse_rules(rules) do
    rules
    |> Enum.map(&String.split(&1, ":"))
    |> Enum.map(fn [rule, range] ->
      [range1, range2] = String.split(range, "or")
      {rule, to_range(range1), to_range(range2)}
    end)
  end

  defp to_range(range) do
    [range_min, range_max] = String.split(range, "-")
    min = range_min |> String.trim() |> String.to_integer()
    max = range_max |> String.trim() |> String.to_integer()
    min..max
  end

  defp parse_my_ticket([my_ticket]) do
    my_ticket |> String.split(",") |> Enum.map(&String.to_integer/1)
  end

  defp parse_nearby_tickets(nearby_tickets) do
    nearby_tickets
    |> Enum.map(&(String.split(&1, ",") |> Enum.map(fn i -> String.to_integer(i) end)))
  end
end
