defmodule Day8.Part1 do

	@doc """
	## Examples
		iex> Input.read(8) |> Day8.Part1.solve
		1600
	"""
	def solve(input) do
		input
		|> Enum.map(&decode_instruction/1)
		|> find_loop(%{cursor: 0, acc: 0})
	end

	defp find_loop(program, %{cursor: cursor, acc: acc}) do
		case program |> instruction_at(cursor) do
			%{visited: true} -> acc
			%{instruction: :jmp, value: val} -> 
				find_loop(
					program |> mark_as_visited(cursor), 
					%{cursor: cursor + val, acc: acc}
				)
			%{instruction: :acc, value: val} -> 
				find_loop(
					program |> mark_as_visited(cursor), 
					%{cursor: cursor + 1, acc: acc + val}
				)
			%{instruction: :nop} -> 
				find_loop(
					program |> mark_as_visited(cursor), 
					%{cursor: cursor + 1, acc: acc}
				)
		end
	end

	def decode_instruction(encoded) do
		[cmd, num] = String.split(encoded)
		%{
			instruction: String.to_atom(cmd), 
			value: String.to_integer(num), 
			visited: false
		} 
	end

	def instruction_at(program, cursorsor) do
		program |> Enum.at(cursorsor)
	end

	def mark_as_visited(program, index) do
		program |> List.replace_at(index, %{instruction: nil, value: nil, visited: true})
	end

end
