defmodule Day8.Part1 do

	@doc """
	## Examples
		iex> Input.read("./lib/day8/input") |> Day8.Part1.solve
		1600
	"""
	def solve(input) do
		%{
			instructions: input |> Enum.map(&decode_instruction/1),
			cursor: 0,
			accumulator: 0
		}
		|> Stream.iterate(&execute_instruction/1)
		|> Enum.find(&already_visited_instruction?/1)
		|> Map.get(:accumulator)
	end

	def execute_instruction(%{instructions: instructions, cursor: cursor, accumulator: accumulator} = state) do
		case instructions |> Enum.at(cursor) do
			%{command: :nop} -> %{state | cursor: cursor + 1}
			%{command: :jmp, value: distance} -> 
				%{
					instructions: instructions |> mark_as_visited(cursor),
					cursor: cursor + distance,
					accumulator: accumulator
				}
			%{command: :acc, value: increment} -> 
				%{
					instructions: instructions |> mark_as_visited(cursor),
					cursor: cursor + 1,
					accumulator: accumulator + increment
				}
		end
	end

	def decode_instruction(encoded) do
		[cmd, num] = String.split(encoded)
		%{
			command: String.to_atom(cmd), 
			value: String.to_integer(num), 
			visited: false
		} 
	end

	def already_visited_instruction?(%{instructions: instructions, cursor: cursor}) do
		instructions |> Enum.at(cursor) |> Map.get(:visited)
	end

	def mark_as_visited(instructions, index) do
		instructions |> List.replace_at(index, %{command: nil, value: nil, visited: true})
	end

end
