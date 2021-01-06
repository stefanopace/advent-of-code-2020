defmodule Day6.Part2 do

	@doc """
	## Examples
		iex> Input.read(6) |> Day6.Part2.solve
		3178
	"""
	def solve(input) do
		input
		|> Input.split_on_blank_lines
		|> Enum.map(fn group -> group |> Enum.map(fn resp -> resp |> String.graphemes |> MapSet.new end) end)
		|> Enum.map(fn group -> group |> Enum.reduce(fn resp, acc -> MapSet.intersection(resp, acc) end) end)
		|> Enum.map(&Enum.count/1)
		|> Enum.sum
	end

end
