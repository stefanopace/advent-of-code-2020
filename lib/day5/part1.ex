defmodule Day5.Part1 do

	@doc """
	## Examples
		iex> Input.read("./lib/day5/input") |> Day5.Part1.solve
		888
	"""
	def solve(input) do
		input
		|> Enum.map(&decode/1)
		|> Enum.max_by(fn {_row, _col, id, _code} -> id end)
		|> elem(2)
	end

	def decode(code) do
		{row_encoded, col_encoded} = String.split_at(code, 7)
		row = 
			row_encoded
			|> String.codepoints
			|> Enum.reverse
			|> Enum.with_index
			|> Enum.map(fn {code, index} -> {code, :math.pow(2,index)} end)
			|> Enum.filter(fn {code, _pow} -> code == "B" end)
			|> Enum.map(fn {_code, pow} -> floor(pow) end)
			|> Enum.sum

		col =
			col_encoded
			|> String.codepoints
			|> Enum.reverse
			|> Enum.with_index
			|> Enum.map(fn {code, index} -> {code, :math.pow(2,index)} end)
			|> Enum.filter(fn {code, _pow} -> code == "R" end)
			|> Enum.map(fn {_code, pow} -> floor(pow) end)
			|> Enum.sum
		
		{row, col, (row * 8) + col, code}
	end

end