defmodule Day3.Part1 do
	@doc """
	## Examples
		iex> Input.read("./lib/day3/input") |> Day3.Part1.solve
		252
	"""
	def solve(input) do
		count_trees(input, 3, 1)
	end

	def count_trees(input, horizontale_move, vertical_move) do
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

end