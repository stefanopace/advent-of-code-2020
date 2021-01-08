alias Day9.Part1, as: Part1

defmodule Day9.Part2 do
	@doc """
	## Examples
		iex> {5, ["35", "20", "15", "25", "47", "40", "62", "55", "65", "95", "102", "117", "150", "182", "127", "219", "299", "277", "309", "576"]} |> Day9.Part2.solve
		62

		# test too slow
		# iex> {25, Input.read(9)} |> Day9.Part2.solve
		# 3340942
	"""
	def solve({preamble_length, input}) do
		numbers = 
			input
			|> Enum.map(fn strnum -> Integer.parse(strnum) |> elem(0) end)
		
		invalid = Part1.find_wrong(numbers, preamble_length)

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
