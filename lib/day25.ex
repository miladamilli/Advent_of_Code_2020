defmodule Day25 do
  @card_public_key 17_607_508
  @door_public_key 15_065_270

  @initial_value 1
  @subject_number 7

  def part1 do
    card_loop_size = loop_size(@subject_number, @card_public_key, @initial_value, 0)
    door_loop_size = loop_size(@subject_number, @door_public_key, @initial_value, 0)
    card_encryption_key = encryption_key(@door_public_key, card_loop_size)
    door_encryption_key = encryption_key(@card_public_key, door_loop_size)
    {card_encryption_key == door_encryption_key, door_encryption_key}
  end

  defp loop_size(_subject_number, public_key, public_key, loop) do
    loop
  end

  defp loop_size(subject_number, public_key, value, loop) do
    loop_size(subject_number, public_key, transform(subject_number, value), loop + 1)
  end

  defp transform(subject_number, value) do
    rem(value * subject_number, 20_201_227)
  end

  defp encryption_key(public_key, loop) do
    Enum.reduce(1..loop, @initial_value, fn _, value -> transform(public_key, value) end)
  end
end
