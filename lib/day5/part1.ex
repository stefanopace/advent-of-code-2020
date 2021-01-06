defmodule Day5.Part1 do

	@doc """
	## Examples
		iex> Input.read("./lib/day5/input") |> Day5.Part1.solve
		888
	"""
	def solve(input) do
		input
		|> Enum.map(&decode_ticket/1)
		|> Enum.max_by(fn {_row, _col, id, _code} -> id end)
		|> elem(2)
	end

	def decode_ticket(code) do
		{row_encoded, col_encoded} = String.split_at(code, 7)
		row = row_encoded |> sum_powers_of_2_matching("B")
		col = col_encoded |> sum_powers_of_2_matching("R")
		
		{row, col, (row * 8) + col, code}
	end

	defp sum_powers_of_2_matching(code, char) do
		code
		|> String.graphemes
		|> Enum.reverse
		|> Enum.with_index
		|> Enum.map(fn {char, index} -> {char, :math.pow(2,index)} end)
		|> Enum.filter(fn {code, _pow} -> code == char end)
		|> Enum.map(fn {_code, pow} -> floor(pow) end)
		|> Enum.sum
	end

end