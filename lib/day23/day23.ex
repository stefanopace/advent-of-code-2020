defmodule Day23 do
	@doc """
	## Examples
		iex> Day23.part1(389125467 |> Integer.digits, 10)
		92658374

		iex> Day23.part1(389125467 |> Integer.digits, 100)
		67384529

		iex> Day23.part1(198753462 |> Integer.digits, 100)
		62934785
	"""
	def part1(input, moves_count) do
		max = 9

		input
		|> to_cyclic_list(max)
		|> (fn map -> {List.first(input), map, 1} end).()
		|> Stream.iterate(&move/1)
		|> Enum.at(moves_count)
		|> compose_solution
	end

	defp compose_solution({_, circle, _}) do
		{_, starting_point} = circle[1]

		join_stop_at_1({circle, starting_point, []})
	end

	defp join_stop_at_1({circle, current_index, acc}) do
		case current_index do
			1 -> acc |> Enum.reverse |> Integer.undigits
			_next -> join_stop_at_1({circle, (circle[current_index] |> elem(1)), [current_index | acc]})
		end
	end

	defp move({current_cup_label, circle, count}) do
		# IO.inspect(
		# 	{
		# 		current_cup_index,
		# 		circle
		# 	}
		# )
		# IO.gets("continue?")
		if rem(count, 100_000) == 0 do
			IO.puts(count)
		end

		{current_prev, current_next} = circle[current_cup_label]
		{_a_prev, a_next} = circle[current_next]
		{_b_prev, b_next} = circle[a_next]
		{c_prev, c_next} = circle[b_next]
		{next_cup_prev, next_cup_next} = circle[c_next]

		circle =
			circle
			|> Map.put(current_cup_label, {current_prev, c_next})
			|> Map.put(c_next, {current_cup_label, next_cup_next})

		destination_label =
			1..4
			|> Stream.map(&(current_cup_label - &1))
			|> Stream.map(fn label -> if label < 1, do: label + map_size(circle), else: label end)
			|> Enum.find(fn label -> not Enum.member?([current_next, a_next, b_next], label) end)

		{destination_prev, destination_next} = circle[destination_label]
			
		{_destination_next_prev, destination_next_next} = circle[destination_next]

		{
			c_next,
			circle
			|> Map.put(destination_label, {destination_prev, current_next})
			|> Map.put(current_next, {destination_label, a_next})
			
			
			|> Map.put(b_next, {c_prev, destination_next})
			|> Map.put(destination_next, {next_cup_prev, destination_next_next}),
			count + 1
		}
	end

	defp to_cyclic_list(list, max) do
		map = 
			list
			|> Enum.with_index
			|> Enum.map(fn {value, index} -> 
				{
					index, 
					{
						value,
						case index do
							0 -> max - 1
							_ -> index - 1
						end,
						case index + 1 do
							^max -> 0
							_ -> index + 1
						end
					}
				}
			end)
			|> Map.new
		
		map
		|> Enum.map(fn {_index, {val, prev, next}} -> 
			{pval, _, _} = map[prev]
			{nval, _, _} = map[next]
			
			{val, {pval, nval}}
		end) 
		|> Map.new
	end


	@doc """
	## Examples
		# iex> Day23.part2(389125467 |> Integer.digits, 100)
		# 12

		# iex> Day23.part2(389125467 |> Integer.digits, 10_000_000)
		# 149245887792

		# iex> Day23.part2(198753462 |> Integer.digits, 10_000_000)
		# 693659135400
	"""
	def part2(input, moves_count) do
		max = 1_000_000

		input ++ ( 10..1_000_000 |> Enum.to_list )
		|> to_cyclic_list(max)
		|> (fn map -> {List.first(input), map, 1} end).()
		|> Stream.iterate(&move/1)
		|> Enum.at(moves_count)
		|> multiply_two_next_to_1
	end

	defp multiply_two_next_to_1({_, circle, _}) do

		{_, first_next} = circle[1]
		{_, second_next} = circle[first_next]
		
		first_next * second_next
	end
end
