defmodule Day20 do
	@doc """
	## Examples
		iex> Input.read("./lib/day20/input_example") |> Day20.part1
		20899048083289

		iex> Input.read(20) |> Day20.part1
		21599955909991
	"""
	def part1(input) do
		tiles = input |> parse_tiles

		tiles
		|> match_borders
		|> find_corners
		|> multiply_ids
			
	end

	@doc """
	## Examples
		iex> Input.read(20) |> Day20.part2
		:result
	"""
	def part2(_input) do
		:result
	end

	defp multiply_ids(tiles) do
		tiles
		|> Enum.map(fn {id, _borders} -> id end)
		|> Enum.reduce(&(&1 * &2))
	end

	defp find_corners(tiles) do
		tiles
		|> Enum.filter(fn {_id, borders} ->
			Enum.count(borders, fn {_border, neighbors} -> neighbors == :edge end) == 2
		end)
	end

	defp match_borders(tiles) do
		tiles
		|> Enum.find_value(false, fn {id, borders} ->
			borders |> Enum.find_value(false, 
			fn 
				{border, nil} -> {id, border, borders}
				_ -> false
			end)
		end)
		|> case do
			false -> tiles
			{id, border, others} ->
				tiles
				|> Map.drop([id])
				|> Enum.find_value(:edge,
					fn {other_id, other_borders} ->
						other_borders
						|> Enum.find_value(
							false, 
							fn 
								{other_border, nil} -> 
									if other_border == border or String.reverse(other_border) == border do
										{other_id, other_border, other_borders}
									else
										false
									end
								_ -> false
							end
						)
					end
				)
				|> (fn 
						{matched_id, matched_border, matched_others} -> match_borders(
							tiles
							|> Map.put(id, Map.put(others, border, matched_id))
							|> Map.put(matched_id, Map.put(matched_others, matched_border, id))
						)
						:edge -> match_borders(
							tiles
							|> Map.put(id, Map.put(others, border, :edge))
						)
				end).()
			end
	end

	defp parse_tiles(input) do
		input
		|> Input.split_on_blank_lines
		|> Enum.map(&parse_tile/1)
		|> Map.new
	end

	defp parse_tile([encoded_id | data]) do
		id = Regex.run(~r/Tile (\d+):/, encoded_id) |> Enum.at(1) |> Integer.parse |> elem(0)

		top = List.first(data)
		right = Enum.map(data, &String.last/1) |> Enum.join
		bottom = List.last(data) |> String.reverse
		left = Enum.map(data, &String.first/1) |> Enum.join |> String.reverse

		{ id, %{top => nil, right => nil, bottom => nil, left => nil} }
	end
end
