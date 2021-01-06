defmodule Day3.Part1 do

	@doc """
	## Examples
		iex> Input.read("./lib/day3/input") |> Day3.Part1.solve
		252
	"""
	def solve(input) do
		count_trees(input, 3, 1)
	end

	def count_trees(input, horizontal_pace, vertical_pace) do
		input
		|> Enum.take_every(vertical_pace)
		|> Enum.map_reduce(0, &(move_horizontally(&1, &2, horizontal_pace))) |> elem(0)
		|> Enum.count(&(&1 == "#"))
	end

	defp move_horizontally(row, position, pace) do
		{	
			row |> String.at(position),
			position + pace |> Integer.mod(String.length(row))
		}
	end

end