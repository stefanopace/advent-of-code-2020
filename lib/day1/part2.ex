defmodule Day1.Part2 do
	@doc """
	## Examples
		iex> ["1721", "979", "366", "299", "675", "1456"] |> Day1.Part2.solve
		241861950

		iex> Input.read("./lib/day1/input") |> Day1.Part2.solve
		6964490
	"""
	def solve(input) do 
		input
		|> Input.to_integers
		|> combine_into_triples
		|> Enum.find_value(fn 
			{a, b, c} when a + b + c == 2020 -> a * b * c
			________________________________ -> false
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