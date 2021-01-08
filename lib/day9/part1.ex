defmodule Day9.Part1 do
	@doc """
	## Examples
		iex> {25, Input.read("./lib/day9/input")} |> Day9.Part1.solve
		25918798
	"""
	def solve({preamble_length, input}) do
		input
		|> Enum.map(&String.to_integer/1)
		|> find_wrong_number(preamble_length)
	end

	def find_wrong_number(numbers, preamble_length) do
		{preamble, [number | _rest]} = Enum.split(numbers, preamble_length)
		if number |> is_sum_of_two(preamble), do: find_wrong_number(tl(numbers), preamble_length), else: number
	end

	defp is_sum_of_two(number, list) do
		(for x <- list, y <- list, do: {x, y})
		|> Enum.filter(fn {x, y} -> x != y end)
		|> Enum.any?(fn {x, y} -> x + y == number end)
	end
end
