alias Day5.Part1, as: Part1

defmodule Day5.Part2 do

	@doc """
	## Examples
		iex> Input.read("./lib/day5/input") |> Day5.Part2.solve
		522
	"""
	def solve(input) do
		input
		|> Enum.map(&Part1.decode/1)
		|> Enum.sort_by(fn {_row, _col, id, _code} -> id end)
		|> Enum.chunk_every(2, 1, :discard)
		|> Enum.find(fn [{_, _, l, _}, {_, _, r, _}] -> r - l != 1 end)
		|> (fn [{_, _, l, _}, {_, _, _, _}] -> l + 1 end).()
	end

end