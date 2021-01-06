alias Day5.Part1, as: Part1

defmodule Day5.Part2 do

	@doc """
	## Examples
		iex> Input.read("./lib/day5/input") |> Day5.Part2.solve
		522
	"""
	def solve(input) do
		input
		|> Enum.map(&Part1.decode_ticket_id/1)
		|> Enum.sort
		|> Enum.chunk_every(2, 1, :discard)
		|> Enum.find_value(fn 
			[prev, next] when next - prev != 1 -> prev + 1
			__________________________________ -> false 
		end)
	end

end