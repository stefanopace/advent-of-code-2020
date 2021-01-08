defmodule Day6.Part1 do

	@doc """
	## Examples
		iex> Input.read("./lib/day6/input") |> Day6.Part1.solve
		6259
	"""
	def solve(input) do
		input
		|> Input.split_on_blank_lines
		|> Enum.map(fn group -> 
			group
			|> Enum.map(&String.graphemes/1)
			|> Enum.map(&MapSet.new/1)
			|> Enum.reduce(&MapSet.union/2)
			|> MapSet.size
		end)
		|> Enum.sum
	end

end
