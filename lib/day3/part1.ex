defmodule Day3.Part1 do
	@doc """
	## Examples
		iex> Input.read("./lib/day3/input") |> Day3.Part1.solve
		252
	"""
	def solve(input) do
		count_trees(input, 3, 1)
	end

	def count_trees(input, horizontal_move, vertical_move) do
		input
		|> Enum.take_every(vertical_move)
		|> Enum.map_reduce(0,
			fn (current, cursor) ->
				{	
					String.at(current, cursor),
					rem(cursor + horizontal_move, String.length(current))
				}
			end
		)
		|> elem(0)
		|> Enum.count(&(&1 == "#"))
	end

end