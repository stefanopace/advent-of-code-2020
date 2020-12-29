defmodule Day6 do
	@doc """
	## Examples
		iex> Input.read(6) |> Day6.part1
		6259
	"""
	def part1(input) do
		input
		|> Input.split_on_blank_lines
		|> Enum.map(fn group -> Enum.flat_map(group, &String.graphemes/1) end)
		|> Enum.map(&Enum.sort/1)
		|> Enum.map(&Enum.dedup/1)
		|> Enum.map(&Enum.count/1)
		|> Enum.sum
	end

	@doc """
	## Examples
		iex> Input.read(6) |> Day6.part2
		3178
	"""
	def part2(input) do
		input
		|> Input.split_on_blank_lines
		|> Enum.map(fn group -> group |> Enum.map(fn resp -> resp |> String.graphemes |> MapSet.new end) end)
		|> Enum.map(fn group -> group |> Enum.reduce(fn resp, acc -> MapSet.intersection(resp, acc) end) end)
		|> Enum.map(&Enum.count/1)
		|> Enum.sum
	end
end
