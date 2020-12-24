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
			{{:jmp, val, _}, _rest} -> find_loop(mark_as_visited(program, cur), %{cur: cur + val, acc: acc})
			{{:acc, val, _}, _rest} -> find_loop(mark_as_visited(program, cur), %{cur: cur + 1, acc: acc + val})
			{{:nop, _val, _}, _rest} -> find_loop(mark_as_visited(program, cur), %{cur: cur + 1, acc: acc})
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
		1543
	"""
	def part2 do
		Input.read(8)
		|> Enum.map(&decode_instruction/1)
		|> traverse(%{cur: 0, acc: 0, fixed: false})
	end

	defp traverse(program, %{cur: cur, acc: acc, fixed: fixed}) do
		if cur == length(program) do
			acc
		else
			case List.pop_at(program, cur) do
				{{_, _, true}, _rest} -> :wrong_path
				{{cmd, val, _}, _rest} ->
					traverse(mark_as_visited(program, cur), next_state(cmd, val, cur, acc, fixed))
					|> case do
						result when cmd == :acc -> result
						:wrong_path when not fixed -> traverse(mark_as_visited(program, cur), swap_instructions(cmd, val, cur, acc, true))
						result -> result
					end
			end
		end
	end

	defp next_state(cmd, val, cur, acc, fixed) do
		%{
			cur: cur + (if cmd == :jmp, do: val, else: 1), 
			acc: acc + (if cmd == :acc, do: val, else: 0),
			fixed: fixed
		}
	end

	defp swap_instructions(cmd, val, cur, acc, fixed) do
		%{
			cur: cur + (if cmd == :jmp, do: 1, else: val), 
			acc: acc, 
			fixed: fixed
		}
	end

	defp mark_as_visited(program, index) do
		List.replace_at(program, index, {nil, nil, true})
	end

end
