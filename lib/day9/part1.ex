defmodule Day9.Part1 do
	@doc """
	## Examples
		iex> {25, Input.read(9)} |> Day9.Part1.solve
		25918798
	"""
	def solve({preamble_length, input}) do
		input
		|> Enum.map(fn strnum -> Integer.parse(strnum) |> elem(0) end)
		|> find_wrong(preamble_length)
	end

	def find_wrong(numbers, preamble_length) do
		{preamble, [number | _rest]} = Enum.split(numbers, preamble_length)
		if is_sum_of_two(number, preamble), do: find_wrong(tl(numbers), preamble_length), else: number
	end

	defp is_sum_of_two(number, list) do
		(for x <- list, y <- list, do: {x, y})
		|> Enum.filter(fn {x, y} -> x != y end)
		|> Enum.any?(fn {x, y} -> x + y == number end)
	end
end
