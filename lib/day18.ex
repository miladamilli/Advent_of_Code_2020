defmodule Day18 do
  def part1 do
    "input/day18.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&eval_line/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  defp eval_line(line) do
    case eval_brackets(line) do
      ^line -> eval_two_numbers(line)
      other -> eval_line(other)
    end
  end

  defp eval_brackets(line) do
    String.replace(line, ~r/\([^()]+\)/, fn expression ->
      expression
      |> String.replace(~r/[()]/, "")
      |> eval_two_numbers()
    end)
  end

  defp eval_two_numbers(expression) do
    new =
      String.replace(
        expression,
        ~r/\d+ [+*] \d+/,
        fn expression ->
          case String.split(expression, [" "]) do
            [a, "+", b] -> to_string(String.to_integer(a) + String.to_integer(b))
            [a, "*", b] -> to_string(String.to_integer(a) * String.to_integer(b))
          end
        end,
        global: false
      )

    case new do
      ^expression -> expression
      other -> eval_two_numbers(other)
    end
  end

  # PART 2 =====================

  def part2 do
    "input/day18.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&eval_line2/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  def eval_line2(line) do
    case eval_brackets2(line) do
      ^line -> eval_two_numbers2(line)
      other -> eval_line2(other)
    end
  end

  defp eval_brackets2(line) do
    String.replace(line, ~r/\([^()]+\)/, fn expression ->
      expression
      |> String.replace(~r/[()]/, "")
      |> eval_two_numbers2()
    end)
  end

  defp eval_two_numbers2(expression) do
    case eval_addition(expression) do
      ^expression -> eval_multiplication(expression)
      other -> eval_two_numbers2(other)
    end
  end

  defp eval_addition(expression) do
    String.replace(expression, ~r/\d+ \+ \d+/, fn expression ->
      [a, b] = String.split(expression, [" + "])
      to_string(String.to_integer(a) + String.to_integer(b))
    end)
  end

  defp eval_multiplication(expression) do
    new =
      String.replace(
        expression,
        ~r/\d+ \* \d+/,
        fn expression ->
          [a, b] = String.split(expression, [" * "])
          to_string(String.to_integer(a) * String.to_integer(b))
        end,
        global: false
      )

    case new do
      ^expression -> expression
      other -> eval_two_numbers(other)
    end
  end
end
