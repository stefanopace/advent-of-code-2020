defmodule Day23 do
	@doc """
	## Examples
		iex> Day23.part1(389125467 |> Integer.digits, 10)
		92658374

		iex> Day23.part1(389125467 |> Integer.digits, 100)
		67384529

		iex> Day23.part1(198753462 |> Integer.digits, 100)
		62934785
	"""
	def part1(input, moves_count) do
		Stream.iterate(input, &(move(&1, 9)))
		|> Enum.at(moves_count)
		|> collect
	end

	@doc """
	## Examples
		iex> Day23.part2(389125467 |> Integer.digits, 1)
		149245887792

		# iex> Day23.part2(198753462 |> Integer.digits, 1000)
		# :result
	"""
	def part2(input, moves_count) do
		input ++ ( 10..999_999 |> Enum.to_list )
		|> Stream.iterate(&(move(&1, 999_999)))
		|> Enum.at(moves_count)
		# |> find_response
	end

	defp find_response([1, a, b | _tail]), do: a * b
	defp find_response([_head | tail]), do: find_response(tail)

	defp collect([1 | tail]), do: tail |> Integer.undigits
	defp collect([h | tail]) do
		collect(tail ++ [h])
	end

	defp move([current_cup, a, b, c | rest], max_cups) do
		picked_up = [a, b, c]
		circle = [current_cup | rest]

		destination_cup =
			1..max_cups
			|> Stream.map(&(current_cup - &1))
			|> Stream.map(fn label -> if label < 1, do: label + max_cups, else: label end)
			|> Enum.find(fn label -> Enum.member?(circle, label) end)
		
		rest
		|> Enum.reduce([], fn cup, merged ->
			case cup do
				^destination_cup -> (picked_up |> Enum.reverse) ++ [destination_cup | merged]
				other_cup -> [other_cup | merged]
			end
		end)
		|> (&([current_cup | &1])).()
		|> Enum.reverse
	end

	@doc """
	## Examples
		iex> Input.read(23) |> Day23.part2
		:result
	"""
	def part2(_input) do
		:result
	end
end