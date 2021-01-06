defmodule Day25 do
	@doc """
	## Examples
		iex> Day25.part1(5764801, 17807724)
		14897079

		# test too slow
		# iex> Day25.part1(12320657, 9659666)
		# 6421487
	"""
	def part1(card_public_key, door_public_key) do
		subject_number = 7

		card_loop_size = find_loop_size(card_public_key, subject_number)
		
		door_public_key
		|> perform_transformation
		|> Enum.at(card_loop_size - 1)
		|> elem(1)
	end

	defp perform_transformation(subject_number) do
		Stream.iterate(1, &(&1 + 1))
		|> Stream.scan({0, 1},
			fn loop_size, {_prev_loop_size, prev_result} ->
				{
					loop_size,
					prev_result * subject_number |> rem(20201227)	
				}
			end
		)
	end

	defp find_loop_size(public_key, subject_number) do
		subject_number
		|> perform_transformation
		|> Enum.find_value(
			fn 
				{loop_size, ^public_key} -> loop_size
				_ -> false 
			end
		)
	end

	@doc """
	## Examples
		# iex> Input.read(25) |> Day25.part2
		# :result
	"""
	def part2(_input) do
		:result
	end
end
