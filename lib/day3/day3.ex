defmodule Day3 do
	defp count_trees(input, horizontale_move, vertical_move) do
		input
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
		iex> Input.read(3) |> Day3.part1
		252
	"""
	def part1(input) do
		count_trees(input, 3, 1)
	end
	
	@doc """
	## Examples
		iex> Input.read(3) |> Day3.part2
		2608962048
	"""
	def part2(input) do
		[{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
		|> Enum.map(fn {h, v} -> count_trees(input, h, v) end)
		|> Enum.reduce(1, fn (cur, mul) -> mul * cur end)
	end
end