defmodule Day15 do
	@doc """
	## Examples
		iex> Day15.part1
		376
	"""
	def part1 do
		starting_numbers = 
			Input.read(15)
			|> List.first
			|> String.split(",")
			|> Enum.map(&(&1 |> Integer.parse |> elem(0)))
			
		starting_turns =
			starting_numbers
			|> Enum.with_index
			|> Enum.map(fn {n, i} -> {n, i + 1} end)
			|> Map.new
			|> (fn memory -> {memory, starting_numbers |> List.last, length(starting_numbers)} end).()
		
		Stream.iterate(starting_turns, &memory_game_turn/1)
		|> Stream.take_while(fn {_, _, turn} -> turn <= 2020 end)
		|> Enum.to_list
		|> List.last
		|> elem(1)
	end

	defp memory_game_turn({memory, last_spoken, turn}) do
		case Map.has_key?(memory, last_spoken) do
			false -> {
				Map.put(memory, last_spoken, turn),
				0,
				turn + 1
			}
			true -> {
				Map.put(memory, last_spoken, turn),
				turn - Map.get(memory, last_spoken),
				turn + 1
			}
		end
	end

	@doc """
	## Examples
		iex> Day15.part2
		:error
	"""
	def part2 do
		:error
	end
end
