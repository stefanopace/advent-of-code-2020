defmodule Day8.Part1 do

	@doc """
	## Examples
		iex> Input.read(8) |> Day8.Part1.solve
		1600
	"""
	def solve(input) do
		input
		|> Enum.map(&decode_instruction/1)
		|> find_loop(%{cur: 0, acc: 0})
	end

	defp find_loop(program, %{cur: cur, acc: acc}) do
		case program |> instruction_at(cur) do
			{_, _, true} -> acc
			{:jmp, val, _} -> find_loop(mark_as_visited(program, cur), %{cur: cur + val, acc: acc})
			{:acc, val, _} -> find_loop(mark_as_visited(program, cur), %{cur: cur + 1, acc: acc + val})
			{:nop, _val, _} -> find_loop(mark_as_visited(program, cur), %{cur: cur + 1, acc: acc})
		end
	end

	def decode_instruction(encoded) do
		[cmd, num] = String.split(encoded)
		{num, _rest} = Integer.parse(num)
		{String.to_atom(cmd), num, false} 
	end

	def instruction_at(program, cursor) do
		{cmd, _rest} = List.pop_at(program, cursor)
		cmd
	end

	def mark_as_visited(program, index) do
		List.replace_at(program, index, {nil, nil, true})
	end

end
