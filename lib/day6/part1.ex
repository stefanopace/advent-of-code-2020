defmodule Day6.Part1 do

	@doc """
	## Examples
		iex> Input.read(6) |> Day6.Part1.solve
		6259
	"""
	def solve(input) do
		input
		|> Input.split_on_blank_lines
		|> Enum.map(fn group -> Enum.flat_map(group, &String.graphemes/1) end)
		|> Enum.map(&MapSet.new/1)
		|> Enum.map(&MapSet.size/1)
		|> Enum.sum
	end

end
