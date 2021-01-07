defmodule Day8.Part1 do

	@doc """
	## Examples
		iex> Input.read(8) |> Day8.Part1.solve
		1600
	"""
	def solve(input) do
		input
		|> Enum.map(&decode_instruction/1)
		|> find_loop(%{cursor: 0, accumulator: 0})
	end

	defp find_loop(program, state = %{cursor: cursor, accumulator: acc}) do
		case program |> instruction_at(cursor) do
			%{visited: true} -> acc
			%{instruction: :jmp, value: distance} -> 
				find_loop(
					program |> mark_as_visited(cursor), 
					state |> move_cursor(distance)
				)
			%{instruction: :acc, value: increment} -> 
				find_loop(
					program |> mark_as_visited(cursor), 
					state |> add_to_accumulator(increment) |> move_cursor(1)
				)
			%{instruction: :nop} -> 
				find_loop(
					program |> mark_as_visited(cursor), 
					state |> move_cursor(1)
				)
		end
	end

	defp move_cursor(state, distance) do
		state |> Map.update!(:cursor, &(&1 + distance))
	end

	defp add_to_accumulator(state, increment) do
		state |> Map.update!(:accumulator, &(&1 + increment))
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
