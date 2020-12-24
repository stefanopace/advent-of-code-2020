defmodule Day10 do
	@doc """
	## Examples
		iex> Day10.part1
		1917
	"""
	def part1 do
		adapters = 
			Input.read(10)
			|> Enum.map(fn strnum -> Integer.parse(strnum) |> elem(0) end)
		
		builtin_adapter = Enum.max(adapters) + 3

		chain = [ 0 ] ++ Enum.sort(adapters) ++ [ builtin_adapter ]

		distribution = 
			chain
			|> Enum.chunk_every(2, 1, :discard)
			|> Enum.map(fn [x, y] -> y - x end)
			|> Enum.group_by(&(&1))
	
		Enum.count(distribution[1]) * Enum.count(distribution[3])
	end

	@doc """
	## Examples
		iex> Day10.part2
		:error
	"""
	def part2 do
		:error
	end
end
