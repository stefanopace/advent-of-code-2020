defmodule Day1 do
	@doc """
	## Examples
		iex> ["1721", "979", "366", "299", "675", "1456"] |> Day1.part1
		514579

		iex> Input.read(1) |> Day1.part1
		776064
	"""
	def part1(input) do
		numbers =
			input
			|> Enum.map(&Integer.parse/1)
			|> Enum.map(fn {parsed, _rest} -> parsed end)
		pairs = for x <- numbers, y <- numbers, do: {x, y}
		{x, y} = Enum.find(pairs, fn {x, y} -> x + y == 2020 end)
		x * y
	end

	@doc """
	## Examples
		iex> ["1721", "979", "366", "299", "675", "1456"] |> Day1.part1
		514579
	"""
	def part2(input) do
		numbers = 
			input
			|> Enum.map(&Integer.parse/1)
			|> Enum.map(fn {parsed, _rest} -> parsed end)
		trines = for x <- numbers, y <- numbers, z <- numbers, do: {x, y, z}
		{x, y, z} = Enum.find(trines, fn {x, y, z} -> x + y + z == 2020 end)
		x * y * z
	end
end