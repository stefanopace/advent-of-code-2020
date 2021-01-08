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
		|> traverse(%{cur: 0, acc: 0, fixed: false})
	end

	defp traverse(program, %{cur: cur, acc: acc, fixed: fixed}) do
		case length(program) do
			^cur -> acc
			_ -> case program |> Enum.at(cur) do
					%{visited: true} -> :wrong_path
					%{instruction: cmd, value: val} ->
						traverse(Part1.mark_as_visited(program, cur), next_state(cmd, val, cur, acc, fixed))
						|> case do
							result when cmd == :acc -> result
							:wrong_path when not fixed -> traverse(Part1.mark_as_visited(program, cur), swap_instructions(cmd, val, cur, acc, true))
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

end
