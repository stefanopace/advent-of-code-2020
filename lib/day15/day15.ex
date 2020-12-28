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
		
		starting_turns
		|> play_until(2020)
	end

	@doc """
	## Examples
		# Test too slow
		#iex> Day15.part2
		#323780
	"""
	def part2 do
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
		
		starting_turns
		|> play_until(30000000)
	end

	defp play_until({memory, last_spoken, turn}, limit) do
		if turn >= limit do
			last_spoken
		else
			case Map.has_key?(memory, last_spoken) do
				false -> play_until({
					Map.put(memory, last_spoken, turn),
					0,
					turn + 1
				}, limit)
				true -> play_until({
					Map.put(memory, last_spoken, turn),
					turn - Map.get(memory, last_spoken),
					turn + 1
				}, limit)
			end
		end
	end
end
