alias Day8.Part1, as: Part1

defmodule Day8.Part2 do

	@doc """
	## Examples
		iex> Input.read("./lib/day8/input") |> Day8.Part2.solve
		1543
	"""
	def solve(input) do
		%{
			instructions: input |> Enum.map(&Part1.decode_instruction/1),
			cursor: 0,
			accumulator: 0,
			already_swapped: false
		}
		|> traverse
	end

	defp traverse(%{instructions: program, cursor: cur, accumulator: acc, already_swapped: already_swapped}) do
		case length(program) do
			^cur -> acc
			_ -> case program |> Enum.at(cur) do
					%{visited: true} -> :wrong_path
					%{instruction: cmd, value: val} ->
						traverse(
							
								next_state(cmd, val, cur, acc, already_swapped, Part1.mark_as_visited(program, cur))
							
						)
						|> case do
							result when cmd == :acc -> result
							:wrong_path when not already_swapped -> traverse(swap_instructions(cmd, val, cur, acc, true, Part1.mark_as_visited(program, cur)))
							result -> result
						end
				end
		end
	end

	defp next_state(cmd, val, cur, acc, already_swapped, instructions) do
		%{
			cursor: cur + (if cmd == :jmp, do: val, else: 1), 
			accumulator: acc + (if cmd == :acc, do: val, else: 0),
			already_swapped: already_swapped,
			instructions: instructions
		}
	end

	defp swap_instructions(cmd, val, cur, acc, already_swapped, instructions) do
		%{
			cursor: cur + (if cmd == :jmp, do: 1, else: val), 
			accumulator: acc, 
			already_swapped: already_swapped,
			instructions: instructions
		}
	end

end
