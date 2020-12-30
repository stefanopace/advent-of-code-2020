defmodule Day20 do
	@doc """
	## Examples
		iex> Input.read("./lib/day20/input_example") |> Day20.part1
		20899048083289

		# iex> Input.read(20) |> Day20.part1
		# 21599955909991
	"""
	def part1(input) do
		tiles = input |> parse_tiles

		tiles
		|> find_top_left_corner
		|> compose_first_line
		# |> compose_the_rest
			
	end

	defp compose_first_line({tiles, [row]}) do
		row |> IO.inspect
		last = List.last(row)
		matched =
			tiles
			|> Enum.find_value(&(match_right(last, &1)))

		case matched do
			nil -> {tiles, [row]}
			{matched_id, _} -> compose_first_line(
				{
					tiles
					|> Enum.reject(fn {id, _} ->
						id == matched_id
					end), 
					[row ++ [matched]]
				}
			)
		end
	end

	defp rotate({id, {[t,r,b,l], data}}) do
		[first | _] = data
		start = first |> String.graphemes |> Enum.map(fn _ -> [] end)
		{
			id,
			{
				[l,t,r,b],
				data
				|> Enum.reduce(start, fn row, partial -> 
					Enum.zip(partial, row |> String.graphemes)
					|> Enum.map(fn {l, r} -> [r | l] end)
				end)
				|> Enum.map(&Enum.join/1)
			}
		}
	end

	defp flip_horizontal({id, {[t,r,b,l], data}}) do
		{
			id,
			{
				[t |> String.reverse, l |> String.reverse, b |> String.reverse, r |> String.reverse],
				data
				|> Enum.map(&String.reverse/1)
			}
		}
	end

	defp find_top_left_corner(tiles) do
		corner = 
			tiles
			|> Enum.find(fn tile ->
				[
					Enum.find(tiles -- [tile], &(match_top(tile, &1))),
					Enum.find(tiles -- [tile], &(match_right(tile, &1))),
					Enum.find(tiles -- [tile], &(match_bottom(tile, &1))),
					Enum.find(tiles -- [tile], &(match_left(tile, &1)))
				]
				|> Enum.filter(fn found -> found end)
				|> Enum.count
				|> Kernel.==(2)
			end)
		
		{tiles -- [corner], [[corner]]}
	end

	@doc """
	## Examples
		iex> Input.read(20) |> Day20.part2
		:result
	"""
	def part2(_input) do
		:result
	end

	defp parse_tiles(input) do
		input
		|> Input.split_on_blank_lines
		|> Enum.map(&parse_tile/1)
	end

	defp parse_tile([encoded_id | data]) do
		id = Regex.run(~r/Tile (\d+):/, encoded_id) |> Enum.at(1) |> Integer.parse |> elem(0)

		top = List.first(data)
		right = Enum.map(data, &String.last/1) |> Enum.join
		bottom = List.last(data) |> String.reverse
		left = Enum.map(data, &String.first/1) |> Enum.join |> String.reverse

		{id, {[top, right, bottom, left], data}}
	end

	defp rotations_of(tile) do
		r90 = rotate(tile)
		r180 = rotate(r90)
		r270 = rotate(r180)
		flipped = flip_horizontal(tile)
		fr90 = rotate(flipped)
		fr180 = rotate(fr90)
		fr270 = rotate(fr180)
		[tile, r90, r180, r270, flipped, fr90, fr180, fr270]
	end

	defp match_right(tile1, tile2) do
		{_, {[_, right, _, _], _}} = tile1

		rotations_of(tile2)
		|> Enum.find(false, fn rotation ->
			{_, {[_, _, _, left], _}} = rotation
			right == String.reverse(left)
		end)
	end

	defp match_top(tile1, tile2) do
		{_, {[top, _, _, _], _}} = tile1

		rotations_of(tile2)
		|> Enum.find(false, fn rotation ->
			{_, {[_, _, bottom, _], _}} = rotation
			top == String.reverse(bottom)
		end)
	end

	defp match_bottom(tile1, tile2) do
		{_, {[_, _, bottom, _], _}} = tile1

		rotations_of(tile2)
		|> Enum.find(false, fn rotation ->
			{_, {[top, _, _, _], _}} = rotation
			bottom == String.reverse(top)
		end)
	end

	defp match_left(tile1, tile2) do
		{_, {[_, _, _, left], _}} = tile1

		rotations_of(tile2)
		|> Enum.find(false, fn rotation ->
			{_, {[_, right, _, _], _}} = rotation
			left == String.reverse(right)
		end)
	end
end
