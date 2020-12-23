defmodule Day1 do
	@doc """
	## Examples
		iex> Day1.part1
		776064
	"""
	def part1 do
		input = 
			Input.read(1)
			|> Enum.map(&Integer.parse/1)
			|> Enum.map(fn {parsed, _rest} -> parsed end)
		pairs = for x <- input, y <- input, do: {x, y}
		{x, y} = Enum.find(pairs, fn {x, y} -> x + y == 2020 end)
		x * y
	end

	@doc """
	## Examples
		#test too slow
		#iex> Day1.part2
		#6964490
	"""
	def part2 do
		input = 
			Input.read(1)
			|> Enum.map(&Integer.parse/1)
			|> Enum.map(fn {parsed, _rest} -> parsed end)
		trines = for x <- input, y <- input, z <- input, do: {x, y, z}
		{x, y, z} = Enum.find(trines, fn {x, y, z} -> x + y + z == 2020 end)
		x * y * z
	end
end