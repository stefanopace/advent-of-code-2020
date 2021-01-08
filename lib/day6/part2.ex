defmodule Day6.Part2 do

	@doc """
	## Examples
		iex> Input.read("./lib/day6/input") |> Day6.Part2.solve
		3178
	"""
	def solve(input) do
		input
		|> Input.split_on_blank_lines
		|> Enum.map(fn group -> 
			group
			|> Enum.map(&String.graphemes/1)
			|> Enum.map(&MapSet.new/1) 
			|> Enum.reduce(&MapSet.intersection/2) 
			|> MapSet.size
		end)
		|> Enum.sum
	end

end
