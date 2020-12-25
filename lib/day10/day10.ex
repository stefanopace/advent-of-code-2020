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
		113387824750592
	"""
	def part2 do
		Input.read(10)
		|> Enum.map(fn strnum -> Integer.parse(strnum) |> elem(0) end)
		|> (fn adapters -> [0] ++ adapters ++ [Enum.max(adapters) + 3] end).()
		|> Enum.sort
		|> Enum.chunk_every(2, 1, :discard)
		|> Enum.map(fn [x, y] -> y - x end)
		|> Enum.chunk_by(&(&1))
		|> Enum.filter(fn group -> Enum.member?(group, 1) end)
		|> Enum.map(&Enum.count/1)
		|> Enum.map(fn count -> 
			case count do
				1 -> 1
				2 -> 2
				3 -> 4
				4 -> 7
			end 
		end)
		|> Enum.reduce(fn x, acc -> x * acc end)
	end
end