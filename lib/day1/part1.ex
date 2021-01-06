defmodule Day1.Part1 do
	@doc """
	## Examples
		iex> ["1721", "979", "366", "299", "675", "1456"] |> Day1.Part1.solve
		514579

		iex> Input.read("./lib/day1/input") |> Day1.Part1.solve
		776064
	"""
	def solve(input) do
		input
		|> Input.to_integers
		|> combine_into_pairs
		|> Enum.find_value(fn 
			{a, b} when a + b == 2020 -> a * b
			_________________________ -> false
		end)
	end

	defp combine_into_pairs(numbers) do
		Stream.flat_map(numbers, fn a ->
			Stream.flat_map(numbers, fn b -> 
				[{a, b}] 
			end) 
		end)
	end
end