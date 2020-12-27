defmodule Day14 do
	@doc """
	## Examples
		iex> Day14.part1
		10717676595607
	"""
	def part1 do
		Input.read(14)
		|> Enum.map(&decode/1)
		|> execute(%{mask: nil, mem: %{}})
		|> sum_values
	end

	defp sum_values(%{mem: mem}) do
		mem
		|> Map.values
		|> Enum.map(fn strval -> Integer.parse(strval, 2) |> elem(0) end)
		|> Enum.sum
	end

	defp execute([instruction | rest], %{mask: mask, mem: mem}) do
		case instruction do
			{:mask, val} -> execute(rest, %{mask: val, mem: mem})
			{:mem, index, val} -> execute(rest, %{mask: mask, mem: Map.put(mem,index, apply_mask(val, mask))})
		end
	end
	defp execute([], state) do
		state
	end

	defp apply_mask(val, mask) do
		Enum.zip(String.graphemes(val), String.graphemes(mask))
		|> Enum.map(fn {origin, mask} ->
			case mask do
				"X" -> origin
				bit -> bit
			end
		end)
		|> List.to_string
	end


	defp decode(line) do
		case Regex.run(~r/(mask|mem)(?:\[([0-9]+)\])? = ([0-9X]+)/, line) do
			[_, "mem", index, value] -> 
				{index, _} = Integer.parse(index)
				{value, _} = Integer.parse(value)
				{:mem, index, value |> Integer.to_string(2) |> String.pad_leading(36, "0")}
			[_, "mask", _, value] -> 
				{:mask, value}
		end
	end

	@doc """
	## Examples
		iex> Day14.part2
		:error
	"""
	def part2 do
		:error
	end
end
