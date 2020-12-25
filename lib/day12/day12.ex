defmodule Day12 do
	@doc """
	## Examples
		iex> Day12.part1
		:error
	"""
	def part1 do
		Input.read(12)
		|> Enum.map(fn encoded -> Regex.run(~r/([A-Z])([0-9]+)/, encoded) end)
		|> Enum.map(fn [_, cmd, val] -> {cmd, val} end)
		|> navigate(%{direction: "L", position: {0, 0}})
	end

	defp navigate(instructions, %{direction: direction, position: {x, y}}) do
		x
	end

	@doc """
	## Examples
		iex> Day12.part2
		:error
	"""
	def part2 do
		:error
	end
end
