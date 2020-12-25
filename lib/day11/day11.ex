defmodule Day11 do
	@doc """
	## Examples
		iex> Day11.part1
		:error
	"""
	def part1 do
		Input.read(11)
		|> to_matrix
		|> stabilize
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

	defp stabilize(seats) do
		seats
		|> compute_next_seats_status
		# |> compare_with_previous_status
		# |> case do
		# 	{:same, _new, _old} -> seats
		# 	{:different, new, _old} -> stabilize(new)
		# end
	end

	defp compute_next_seats_status(seats) do
		seats |> Enum.map(fn {i, row} -> 
			{
				i, row |> Enum.map(fn {j, seat} ->
					{ j , case seat do 
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
					}
				end) |> Map.new
			}
		end) |> Map.new
	end

	defp seat_is_occupied(seat) do
		seat == ?#
	end

	@doc """
	## Examples
		iex> Day11.part2
		:error
	"""
	def part2 do
		:error
	end
end
