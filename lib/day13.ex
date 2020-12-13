defmodule Day13 do
  @depart 1_005_595
  @buses "41,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,37,x,x,x,x,x,557,x,29,x,x,x,x,x,x,x,x,x,x,13,x,x,x,17,x,x,x,x,x,23,x,x,x,x,x,x,x,419,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,19"

  def part1 do
    run(@buses, @depart)
  end

  def run(buses, depart) do
    buses = parse(buses)
    bus = Enum.min_by(buses, fn bus -> waiting_time(bus, depart) end)
    waiting_time(bus, depart) * bus
  end

  defp waiting_time(bus, depart) do
    div(depart, bus) * bus + bus - depart
  end

  def parse(buses) do
    buses
    |> String.split(",")
    |> Enum.reject(&(&1 == "x"))
    |> Enum.map(&String.to_integer/1)
  end

  # PART 2 =======================================================

  def part2 do
    run2(@buses)
  end

  def run2(buses) do
    buses
    |> String.split(",")
    |> Enum.with_index()
    |> Enum.reject(fn {bus, _index} -> bus == "x" end)
    |> Enum.map(fn {bus, index} -> {String.to_integer(bus), index} end)
    |> find_times
  end

  defp find_times([{_bus1, time1}]) do
    time1
  end

  defp find_times([{bus1, time1}, {bus2, time2} | buses]) do
    new_time = time1 + bus1

    if rem(new_time + time2, bus2) != 0 do
      find_times([{bus1, new_time}, {bus2, time2} | buses])
    else
      xx = find_times2([{bus1, new_time}, {bus2, time2}])

      find_times([{xx - new_time, new_time} | buses])
    end
  end

  defp find_times2([{bus1, time1}, {bus2, time2}]) do
    new_time = time1 + bus1

    if rem(new_time + time2, bus2) != 0 do
      find_times2([{bus1, new_time}, {bus2, time2}])
    else
      new_time
    end
  end
end
