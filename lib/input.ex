defmodule Input do
  def file_numbers(file) do
    File.read!("input/" <> file <> ".txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
