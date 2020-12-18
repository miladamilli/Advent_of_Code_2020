defmodule Day18 do
  def part1 do
    "input/day18.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> run
  end

  defp run(data) do
    data
    |> Enum.map(&eval_line/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  defp eval_line(line) do
    new_line =
      line
      |> eval_brackets
      |> eval_expressions

    if line != new_line, do: eval_line(new_line), else: line
  end

  defp eval_expressions(line) do
    line
    |> String.replace(
      ~r/\d+\s[\*\+]\s\d+/,
      fn expression ->
        {result, _} = Code.eval_string(expression)
        Integer.to_string(result)
      end,
      global: false
    )
  end

  defp eval_brackets(line) do
    new_line =
      line
      |> String.replace(
        ~r/\(\d+\s[\*\+]\s\d+\)/,
        fn expression ->
          {result, _} = Code.eval_string(expression)
          Integer.to_string(result)
        end
      )

    if new_line != line do
      eval_brackets(new_line)
    else
      line
    end
  end
end
