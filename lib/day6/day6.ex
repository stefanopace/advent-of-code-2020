defmodule Day6 do
	@doc """
	## Examples
		iex> Day6.part1
		6259
	"""
	def part1 do
		Input.read(6)
		|> Input.split_on_blank_lines
		|> Enum.map(fn group -> Enum.flat_map(group, &String.graphemes/1) end)
		|> Enum.map(&Enum.sort/1)
		|> Enum.map(&Enum.dedup/1)
		|> Enum.map(&Enum.count/1)
		|> Enum.sum
	end

	@doc """
	## Examples
		iex> Day6.part1
		:error
	"""
	def part2 do
		
	end
end
