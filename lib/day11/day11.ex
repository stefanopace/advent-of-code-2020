defmodule Day11 do
	@doc """
	## Examples
		iex> [
		...>	"L.LL.LL.LL",
		...>	"LLLLLLL.LL",
		...>	"L.L.L..L..",
		...>	"LLLL.LL.LL",
		...>	"L.LL.LL.LL",
		...>	"L.LLLLL.LL",
		...>	"..L.L.....",
		...>	"LLLLLLLLLL",
		...>	"L.LLLLLL.L",
		...>	"L.LLLLL.LL",
		...>] |> Day11.part1
		37

		# test too slow
		# iex> Input.read(11) |> Day11.part1
		# 2303
	"""
	def part1(input) do
		input
		|> to_matrix
		|> stabilize(&apply_part1_rules/4)
		|> count_occupied_seats
	end

	@doc """
	## Examples
		iex> [
		...>	"L.LL.LL.LL",
		...>	"LLLLLLL.LL",
		...>	"L.L.L..L..",
		...>	"LLLL.LL.LL",
		...>	"L.LL.LL.LL",
		...>	"L.LLLLL.LL",
		...>	"..L.L.....",
		...>	"LLLLLLLLLL",
		...>	"L.LLLLLL.L",
		...>	"L.LLLLL.LL",
		...>] |> Day11.part2
		26

		# test too slow
		# iex> Input.read(11) |> Day11.part2
		# 2057
	"""
	def part2(input) do
		input
		|> to_matrix
		|> stabilize(&apply_part2_rules/4)
		|> count_occupied_seats
	end

	defp count_occupied_seats(seats) do
		seats 
		|> Map.values
		|> Enum.map(&Map.values/1)
		|> List.flatten
		|> Enum.count(&(&1 == ?#))
	end

	defp to_matrix(input) do
		input
		|> Enum.with_index
		|> Enum.map(fn {row, rownum} -> 
			{
				rownum, 
				row 
				|> String.to_charlist 
				|> Enum.with_index 
				|> Enum.map(fn {seat, colnum} -> {colnum, seat} end)
				|> Map.new
			} 
		end)
		|> Map.new
	end

	defp stabilize(seats, rules_to_apply) do
		seats
		|> compute_next_seats_status(rules_to_apply)
		|> compare_with_previous_status
		|> case do
		 	{:same, _old, _new} -> seats
		 	{:different, _old, new} -> stabilize(new, rules_to_apply)
		end
	end

	defp compare_with_previous_status({prev, current}) do
		if Map.equal?(prev, current) do
			{:same, prev, current}
		else
			{:different, prev, current}
		end
	end

	defp map_each_seat(seats, map_function) do
		seats |> Enum.map(fn {i, row} -> 
			{ i, row |> Enum.map(
				fn {j, seat} ->
					{j, map_function.(seats, i, j, seat)}
				end
			) |> Map.new}
		end) |> Map.new
	end

	defp apply_part1_rules(seats, i, j, seat) do
		case seat do 
			?. -> ?.
			?L -> 
				[{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1},]
				|> Enum.map(fn {i_shift, j_shift} -> seats[i + i_shift][j + j_shift] end)
				|> Enum.count(&seat_is_occupied/1)
				|> case do
					count when count == 0 -> ?#
					_ -> ?L
				end
			?# ->
				[{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1},]
				|> Enum.map(fn {i_shift, j_shift} -> seats[i + i_shift][j + j_shift] end)
				|> Enum.count(&seat_is_occupied/1)
				|> case do
					count when count >= 4 -> ?L
					_ -> ?#
				end
		end
	end

	defp apply_part2_rules(seats, i, j, seat) do
		case seat do 
			?. -> ?.
			?L -> 
				[{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1},]
				|> Enum.map(fn direction -> first_seat_status_following_direction(seats, i, j, direction) end)
				|> Enum.count(&seat_is_occupied/1)
				|> case do
					count when count == 0 -> ?#
					_ -> ?L
				end
			?# ->
				[{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1},]
				|> Enum.map(fn direction -> first_seat_status_following_direction(seats, i, j, direction) end)
				|> Enum.count(&seat_is_occupied/1)
				|> case do
					count when count >= 5 -> ?L
					_ -> ?#
				end
		end
	end

	defp first_seat_status_following_direction(seats, i, j, {i_shift, j_shift}) do
		case seats[i + i_shift][j + j_shift] do
			?. -> first_seat_status_following_direction(seats, i + i_shift, j + j_shift, {i_shift, j_shift})
			status -> status
		end
	end

	defp compute_next_seats_status(seats, rules_to_apply) do
		{
			seats,
			seats |> map_each_seat(rules_to_apply)
		}
	end

	defp seat_is_occupied(seat) do
		seat == ?#
	end
end
