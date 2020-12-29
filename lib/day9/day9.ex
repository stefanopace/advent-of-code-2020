defmodule Day9 do
	@doc """
	## Examples
		iex> {25, Input.read(9)} |> Day9.part1
		25918798
	"""
	def part1({preamble_length, input}) do
		input
		|> Enum.map(fn strnum -> Integer.parse(strnum) |> elem(0) end)
		|> find_wrong(preamble_length)
	end

	defp find_wrong(numbers, preamble_length) do
		{preamble, [number | _rest]} = Enum.split(numbers, preamble_length)
		if is_sum_of_two(number, preamble), do: find_wrong(tl(numbers), preamble_length), else: number
	end

	defp is_sum_of_two(number, list) do
		(for x <- list, y <- list, do: {x, y})
		|> Enum.filter(fn {x, y} -> x != y end)
		|> Enum.any?(fn {x, y} -> x + y == number end)
	end

	@doc """
	## Examples
		iex> {5, ["35", "20", "15", "25", "47", "40", "62", "55", "65", "95", "102", "117", "150", "182", "127", "219", "299", "277", "309", "576"]} |> Day9.part2
		62

		# test too slow
		# iex> {25, Input.read(9)} |> Day9.part2
		# 3340942
	"""
	def part2({preamble_length, input}) do
		numbers = 
			input
			|> Enum.map(fn strnum -> Integer.parse(strnum) |> elem(0) end)
		
		invalid = find_wrong(numbers, preamble_length)

		find_weak_sequence(numbers, invalid, [])
		|> Enum.min_max
		|> (fn {min, max} -> min + max end).()

	end

	defp find_weak_sequence(numbers, invalid, current_sequence) do
		case Enum.sum(current_sequence) do
			^invalid -> current_sequence
			sum when sum > invalid -> find_weak_sequence(tl(numbers), invalid, [])
			_sum -> find_weak_sequence(numbers, invalid, [Enum.at(numbers, length(current_sequence)) | current_sequence])
		end
	end
end
