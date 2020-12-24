defmodule Day8 do
	@doc """
	## Examples
		iex> Day8.part1
		1600
	"""
	def part1 do
		Input.read(8)
		|> Enum.map(&decode_instruction/1)
		|> find_loop(%{cur: 0, acc: 0})
	end

	defp find_loop(program, %{cur: cur, acc: acc}) do
		case List.pop_at(program, cur) do
			{{_, _, true}, _rest} -> acc
			{{:jmp, val, _}, _rest} -> find_loop(List.replace_at(program, cur, {:jpm, val, true}), %{cur: cur + val, acc: acc})
			{{:acc, val, _}, _rest} -> find_loop(List.replace_at(program, cur, {:acc, val, true}), %{cur: cur + 1, acc: acc + val})
			{{:nop, val, _}, _rest} -> find_loop(List.replace_at(program, cur, {:nop, val, true}), %{cur: cur + 1, acc: acc})
		end
	end

	defp decode_instruction(encoded) do
		[cmd, num] = String.split(encoded)
		{num, _rest} = Integer.parse(num)
		{String.to_atom(cmd), num, false} 
	end

	@doc """
	## Examples
		iex> Day8.part2
		:error
	"""
	def part2 do
		:error
	end
end
