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
    |> find_times()
  end

  defp find_times([{_bus, offset}]) do
    offset
  end

  defp find_times([bus1, bus2 | buses]) do
    new_virtual_bus = find_mutual_stop(bus1, bus2)
    find_times([new_virtual_bus | buses])
  end

  defp find_mutual_stop({bus1_interval, offset1}, {bus2_interval, offset2}) do
    [first_mutual_stop, second_mutual_stop] =
      offset1
      |> Stream.unfold(fn o -> {o, o + bus1_interval} end)
      |> Stream.filter(fn stop -> rem(stop + offset2, bus2_interval) == 0 end)
      |> Enum.take(2)

    interval = second_mutual_stop - first_mutual_stop
    {interval, first_mutual_stop}
  end
end
