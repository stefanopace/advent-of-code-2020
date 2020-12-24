defmodule Day9 do
	@doc """
	## Examples
		iex> Day9.part1
		25918798
	"""
	def part1 do
		Input.read(9)
		|> Enum.map(fn strnum -> Integer.parse(strnum) |> elem(0) end)
		|> find_wrong()
	end

	defp find_wrong(numbers) do
		{preamble, [number | _rest]} = Enum.split(numbers, 25)
		if is_sum_of_two(number, preamble), do: find_wrong(tl(numbers)), else: number
	end

	defp is_sum_of_two(number, list) do
		for x <- list, y <- list do
			{x, y}
		end
		|> Enum.filter(fn {x, y} -> x != y end)
		|> Enum.any?(fn {x, y} -> x + y == number end)
	end

	@doc """
	## Examples
		iex> Day9.part2
		:error
	"""
	def part2 do
		:error
	end
end
