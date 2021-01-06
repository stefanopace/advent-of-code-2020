alias Day3.Part1, as: Part1

defmodule Day3.Part2 do

	@doc """
	## Examples
		iex> Input.read("./lib/day3/input") |> Day3.Part2.solve
		2608962048
	"""
	def solve(input) do
		[{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
		|> Enum.map(fn {h_pace, v_pace} -> Part1.count_trees(input, h_pace, v_pace) end)
		|> Enum.reduce(&(&1 * &2))
	end

end