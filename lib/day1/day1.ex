defmodule Day1 do
	def part1 do
		input = 
			Input.read(1)
			|> Enum.map(&Integer.parse/1)
			|> Enum.map(fn {parsed, _rest} -> parsed end)
		pairs = for x <- input, y <- input, do: {x, y}
		{x, y} = Enum.find(pairs, fn {x, y} -> x + y == 2020 end)
		x * y
	end

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