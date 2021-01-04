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
		input
		|> Stream.iterate(&(move(&1, 9)))
		|> Enum.at(moves_count)
		|> collect
	end

	@doc """
	## Examples
		iex> Day23.part2(389125467 |> Integer.digits, 100)
		149245887792

		# iex> Day23.part2(198753462 |> Integer.digits, 1000)
		# :result
	"""
	def part2(input, moves_count) do
		input ++ ( 10..1_000_000 |> Enum.to_list )
		|> Stream.iterate(&(move(&1, 1_000_000)))
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

		destination_cup =
			1..max_cups
			|> Stream.map(&(current_cup - &1))
			|> Stream.map(fn label -> if label < 1, do: label + max_cups, else: label end)
			|> Enum.find(fn label -> not Enum.member?(picked_up, label) end)
		
		rest
		|> position_picked_up_cups([], picked_up, destination_cup)
		|> (&([current_cup | &1])).()
		|> Enum.reverse
	end

	defp position_picked_up_cups([label | rest], merged, picked_up, destination_cup) do
		case label do
			^destination_cup -> (rest |> Enum.reverse) ++ (picked_up |> Enum.reverse) ++ [destination_cup | merged]
			_other_cup -> position_picked_up_cups(rest, [label | merged], picked_up, destination_cup)
		end
	end
end
