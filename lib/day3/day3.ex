defmodule Day3 do
	defp count_trees(horizontale_move, vertical_move) do
		Input.read(3)
		|> Enum.take_every(vertical_move)
		|> Enum.reduce(
			{0, []},
			fn (current, {cursor, prev}) ->
				{
					rem(cursor + horizontale_move, String.length(current)),
					[String.at(current, cursor) | prev]
				}
			end
		)
		|> elem(1)
		|> Enum.count(&(&1 == "#"))
	end

	@doc """
	## Examples
		iex> Day3.part1
		252
	"""
	def part1 do
		count_trees(3, 1)
	end
	
	@doc """
	## Examples
		iex> Day3.part2
		2608962048
	"""
	def part2 do
		[{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
		|> Enum.map(fn {h, v} -> count_trees(h, v) end)
		|> Enum.reduce(1, fn (cur, mul) -> mul * cur end)
	end
end