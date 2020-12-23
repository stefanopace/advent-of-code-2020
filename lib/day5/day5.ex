defmodule Day5 do

	@doc """
	## Examples
		iex> Day5.part1
		888
	"""
	def part1 do
		Input.read(5)
		|> Enum.map(&decode/1)
		|> Enum.max_by(fn {_row, _col, id, _code} -> id end)
		|> elem(2)
	end

	@doc """
	## Examples
		iex> Day5.part2
		522
	"""
	def part2 do
		Input.read(5)
		|> Enum.map(&decode/1)
		|> Enum.sort_by(fn {_row, _col, id, _code} -> id end)
		|> Enum.chunk_every(2, 1, :discard)
		|> Enum.find(fn [{_, _, l, _}, {_, _, r, _}] -> r - l != 1 end)
		|> (fn [{_, _, l, _}, {_, _, _, _}] -> l + 1 end).()
	end

	defp decode(code) do
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