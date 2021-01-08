alias Day8.Part1, as: Part1

defmodule Day8.Part2 do

	@doc """
	## Examples
		iex> Input.read("./lib/day8/input") |> Day8.Part2.solve
		1543
	"""
	def solve(input) do
		input
		|> Enum.map(&Part1.decode_instruction/1)
		|> all_possible_programs
		|> Stream.map(&execute_program/1)
		|> Enum.find(&program_terminated?/1)
		|> (fn ({:terminated, %{accumulator: accumulator}}) -> accumulator end).()
	end

	defp execute_program(initial_state) do
		initial_state
		|> Stream.iterate(&Part1.execute_instruction/1)
		|> Enum.find_value(fn state ->
			cond do
				state |> is_cursor_after_last_instruction? -> {:terminated, state}
				state |> Part1.already_visited_instruction? -> {:infinite_loop, state}
				true -> false
			end
		end)
	end

	defp is_cursor_after_last_instruction?(%{instructions: instructions, cursor: cursor}) do
		length(instructions) == cursor
	end

	defp program_terminated?({:terminated, _state}), do: true
	defp program_terminated?(_), do: false

	defp all_possible_programs(instructions) do
		instructions
		|> Stream.with_index
		|> Stream.filter(fn 
			{%{command: :jmp}, _index} -> true
			{%{command: :nop}, _index} -> true
			__________________________ -> false
		end)
		|> Stream.map(fn {_, index} -> instructions |> List.update_at(index, &swap_jmp_and_nop/1) end)
		|> Stream.map(fn instructions ->
			%{
				instructions: instructions,
				cursor: 0,
				accumulator: 0
			}
		end)
	end

	defp swap_jmp_and_nop(%{command: :jmp} = instruction), do: %{instruction | command: :nop}
	defp swap_jmp_and_nop(%{command: :nop} = instruction), do: %{instruction | command: :jmp}

end
