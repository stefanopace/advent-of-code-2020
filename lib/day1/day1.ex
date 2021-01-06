defmodule Day1 do
	@doc """
	## Examples
		iex> ["1721", "979", "366", "299", "675", "1456"] |> Day1.part1
		514579

		iex> Input.read("./lib/day1/input") |> Day1.part1
		776064
	"""
	def part1(input) do
		input
		|> to_integers
		|> combine_into_pairs
		|> Enum.find_value(fn 
			{a, b} when a + b == 2020 -> a * b
			_________________________ -> false
		end)
	end

	@doc """
	## Examples
		iex> ["1721", "979", "366", "299", "675", "1456"] |> Day1.part1
		514579

		iex> Input.read("./lib/day1/input") |> Day1.part2
		6964490
	"""
	def part2(input) do 
		input
		|> to_integers
		|> combine_into_triples
		|> Enum.find_value(fn 
			{a, b, c} when a + b + c == 2020 -> a * b * c
			________________________________ -> false
		end)
	end

	defp to_integers(numbers), do: numbers |> Stream.map(&String.to_integer/1)

	defp combine_into_pairs(numbers) do
		Stream.flat_map(numbers, fn a ->
			Stream.flat_map(numbers, fn b -> 
				[{a, b}] 
			end) 
		end)
	end

	defp combine_into_triples(numbers) do
		Stream.flat_map(numbers, fn a -> 
			Stream.flat_map(numbers, fn b -> 
				Stream.flat_map(numbers, fn c -> 
					[{a, b, c}] 
				end) 
			end) 
		end)
	end
end