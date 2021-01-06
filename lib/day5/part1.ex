defmodule Day5.Part1 do

	@doc """
	## Examples
		iex> Input.read("./lib/day5/input") |> Day5.Part1.solve
		888
	"""
	def solve(input), do: input |> Enum.map(&decode_ticket_id/1) |> Enum.max

	def decode_ticket_id(code) do
		{row_encoded, col_encoded} = code |> String.split_at(7)
		row = row_encoded |> sum_powers_of_2_matching("B")
		col = col_encoded |> sum_powers_of_2_matching("R")
		
		(row * 8) + col
	end

	defp sum_powers_of_2_matching(code, char) do
		code
		|> String.graphemes
		|> Enum.reverse
		|> Enum.zip(powers_of_2())
		|> Enum.filter(fn 
			{^char, _pow} -> true
			_____________ -> false
		end)
		|> Enum.map(&(elem(&1, 1)))
		|> Enum.sum
	end

	defp powers_of_2, do: Stream.iterate(1, &(&1 * 2))

end