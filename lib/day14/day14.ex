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

	@doc """
	## Examples
		iex> Day14.part2
		3974538275659
	"""
	def part2 do
		Input.read(14)
		|> Enum.map(&decode/1)
		|> execute_v2(%{mask: nil, mem: %{}})
		|> sum_values
	end

	defp execute_v2([instruction | rest], %{mask: mask, mem: mem}) do
		case instruction do
			{:mask, val} -> execute_v2(rest, %{mask: val, mem: mem})
			{:mem, index, val} -> 
				execute_v2(
					rest, 
					%{
						mask: mask, 
						mem: 
							index
							|> apply_mask_v2(mask)
							|> generate_memory_addresses
							|> Enum.reduce(mem, fn address, state -> Map.put(state, address, val) end)
					}
				)
		end
	end
	defp execute_v2([], state) do
		state
	end

	defp apply_mask_v2(index, mask) do
		bin_index = Integer.to_string(index, 2) |> String.pad_leading(36, "0")

		Enum.zip(String.graphemes(bin_index), String.graphemes(mask))
		|> Enum.map(fn {bit, mask} -> 
			case mask do
				"0" -> bit
				"1" -> mask
				"X" -> "X"
			end
		end)
	end

	defp generate_memory_addresses(address) do
		address
		|> Enum.reverse
		|> Enum.reduce([[]], fn bit, addresses -> 
			case bit do
				"X" -> addresses |> Enum.reduce([], fn address, acc -> 
					[["1" | address], ["0" | address] | acc]
				end)
				bit -> addresses |> Enum.map(&([bit | &1]))
			end
		end)
		|> Enum.map(&List.to_string/1)
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
end
