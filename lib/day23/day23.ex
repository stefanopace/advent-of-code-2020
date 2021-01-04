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
		|> (fn map -> {0, map} end).()
		|> Stream.iterate(&(move(&1, max)))
		|> Enum.at(moves_count)
		|> compose_solution
	end

	defp compose_solution({_, circle}) do
		{_, {_, _, starting_point}} = 
			circle
			|> Enum.find(fn {_, {val, _, _}} -> val == 1 end)

		join_stop_at_1({circle, starting_point, []})
	end

	defp join_stop_at_1({circle, current_index, acc}) do
		case circle[current_index] do
			{1, _, _} -> acc |> Enum.reverse |> Integer.undigits
			{val, _prev, next} -> join_stop_at_1({circle, next, [val | acc]})
		end
	end

	defp move({current_cup_index, circle}, max_cups) do
		# IO.inspect(
		# 	{
		# 		current_cup_index,
		# 		circle
		# 	}
		# )
		# IO.gets("continue?")
		current_cup = {current_cup_label, current_prev, current_next} = circle[current_cup_index]
		a = {a_label, _a_prev, a_next} = current_cup |> next(circle)
		b = {b_label, _b_prev, b_next} = a |> next(circle)
		c = {c_label, c_prev, c_next} = b |> next(circle)
		{next_cup_label, next_cup_prev, next_cup_next} = c |> next(circle)

		circle =
			circle
			|> Map.put(current_cup_index, {current_cup_label, current_prev, c_next})
			|> Map.put(c_next, {next_cup_label, current_cup_index, next_cup_next})

		destination_label =
			1..map_size(circle)
			|> Stream.map(&(current_cup_label - &1))
			|> Stream.map(fn label -> if label < 1, do: label + map_size(circle), else: label end)
			|> Enum.find(fn label -> not Enum.member?([a_label, b_label, c_label], label) end)

		{destination_index, {_, destination_prev, destination_next}} =
			circle
			|> search_destination_cup_backward(current_prev, destination_label)

		# si puo ottimizzare evitando di chiamare la funzione next... circle[destination_next]
		{destination_next_label, _destination_next_prev, destination_next_next} = {destination_label, destination_prev, destination_next} |> next(circle)

		{
			c_next,
			circle
			|> Map.put(destination_index, {destination_label, destination_prev, current_next})
			|> Map.put(current_next, {a_label, destination_index, a_next})
			|> Map.put(b_next, {c_label, c_prev, destination_next})
			|> Map.put(destination_next, {destination_next_label, next_cup_prev, destination_next_next})
		}
		
	end

	defp search_destination_cup_backward(circle, current_prev, destination_label) do
		maybe_destination_cup = {prev_label, prev_prev, _} = circle[current_prev]

		case prev_label do
			^destination_label -> {current_prev, maybe_destination_cup}
			_ -> search_destination_cup_backward(circle, prev_prev, destination_label)
		end
	end

	defp next(node, cyclic_list) do
		cyclic_list[(node |> elem(2))]
	end

	defp to_cyclic_list(list, max) do
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
	end


	@doc """
	## Examples
		iex> Day23.part2(389125467 |> Integer.digits, 10_000_000)
		149245887792

		# # iex> Day23.part2(198753462 |> Integer.digits, 1000)
		# # :result
	"""
	def part2(input, moves_count) do
		max = 1_000_000

		input ++ ( 10..1_000_000 |> Enum.to_list )
		|> to_cyclic_list(max)
		|> (fn map -> {0, map} end).()
		|> Stream.iterate(&(move(&1, max)))
		|> Enum.at(moves_count)
		|> multiply_two_next_to_1
	end

	defp multiply_two_next_to_1({_, circle}) do
		{_, {_, _, first_next}} = 
			circle
			|> Enum.find(fn {_, {val, _, _}} -> val == 1 end)

		{val1, _, second_next} = circle[first_next]
		{val2, _, _} = circle[second_next]
		
		val1 * val2
	end
end
