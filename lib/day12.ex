defmodule Day12 do
  def part1 do
    "input/day12.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> run({0, 0}, "E")
  end

  def run([], {x, y}, _direction) do
    abs(x) + abs(y)
  end

  def run([instr | rest], position, direction) do
    {new_position, new_dir} = move(instr, position, direction)
    run(rest, new_position, new_dir)
  end

  defp move(<<char>> <> value, {x, y}, direction) do
    value = String.to_integer(value)

    case char do
      ?N -> {{x, y + value}, direction}
      ?S -> {{x, y - value}, direction}
      ?E -> {{x + value, y}, direction}
      ?W -> {{x - value, y}, direction}
      ?F -> {move_forward({x, y}, direction, value), direction}
      _ -> {{x, y}, turn(char, direction, value)}
    end
  end

  @directions ~w(N E S W)
  defp turn(turn_dir, direction, degrees) do
    dir = Enum.find_index(@directions, fn d -> d == direction end)
    turn = div(degrees, 2)

    case turn_dir do
      ?L -> Enum.at(@directions, rem(4 + dir - turn, 4))
      ?R -> Enum.at(@directions, rem(dir + turn, 4))
    end
  end

  defp move_forward({x, y}, direction, value) do
    case direction do
      "N" -> {x, y + value}
      "S" -> {x, y - value}
      "E" -> {x + value, y}
      "W" -> {x - value, y}
    end
  end

  # PART 2 =======================================================

  def part2 do
    "input/day12.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> run2({0, 0}, {10, 1})
  end

  def run2([], {x, y}, _waypoint) do
    abs(x) + abs(y)
  end

  def run2([instr | rest], position, waypoint) do
    {new_position, waypoint} = move2(instr, position, waypoint)
    run2(rest, new_position, waypoint)
  end

  defp move2(<<char>> <> value, point, {wx, wy} = waypoint) do
    value = String.to_integer(value)

    case char do
      ?N -> {point, {wx, wy + value}}
      ?S -> {point, {wx, wy - value}}
      ?E -> {point, {wx + value, wy}}
      ?W -> {point, {wx - value, wy}}
      ?F -> {move_forward2(point, waypoint, value), waypoint}
      _ -> {point, turn2(char, waypoint, value)}
    end
  end

  defp turn2(action, waypoint, value) do
    count = div(value, 90)

    Enum.reduce(1..count, waypoint, fn _, {wx, wy} ->
      if action == ?R, do: {wy, -wx}, else: {-wy, wx}
    end)
  end

  defp move_forward2({x, y}, {wx, wy}, value) do
    {x + wx * value, y + wy * value}
  end
end
