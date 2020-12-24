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
		(for x <- list, y <- list, do: {x, y})
		|> Enum.filter(fn {x, y} -> x != y end)
		|> Enum.any?(fn {x, y} -> x + y == number end)
	end

	@doc """
	## Examples
		iex> Day9.part2
		3340942
	"""
	def part2 do
		numbers = 
			Input.read(9)
			|> Enum.map(fn strnum -> Integer.parse(strnum) |> elem(0) end)
		
		invalid = find_wrong(numbers)

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
