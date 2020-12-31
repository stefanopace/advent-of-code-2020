defmodule Day20 do
	@doc """
	## Examples
		iex> Input.read("./lib/day20/input_example") |> Day20.part1
		20899048083289

		# iex> Input.read(20) |> Day20.part1
		# 21599955909991
	"""
	def part1(input) do
		input 
		|> parse_tiles
		|> pick_one_tile
		|> connect_other_tiles
	end

	defp connect_other_tiles({[], canvas}) do
		canvas	
	end
	defp connect_other_tiles({tile_bag, canvas}) do
		canvas
		|> find_a_tile_missing_a_neighbor
		|> find_the_missing_neighbor(tile_bag)
	end

	defp find_the_missing_neighbor({canvas, {{{x, y}, tile}, direction}}, tile_bag) do
		neighbor = 
			tile_bag
			|> Enum.find_value(
				:edge, 
				fn tile_in_the_bag -> 
					rotations_of(tile_in_the_bag)
					|> Enum.find(false, fn rotated_tile -> tile |> connects?(rotated_tile, direction) end)
				end)
	end

	defp rotations_of(tile) do
		r90 = rotate(tile)
		r180 = rotate(r90)
		r270 = rotate(r180)
		flipped = flip(tile)
		fr90 = rotate(flipped)
		fr180 = rotate(fr90)
		fr270 = rotate(fr180)
		[tile, r90, r180, r270, flipped, fr90, fr180, fr270]
	end

	defp rotate({id, data}) do
		rotated = 
			data
			|> Enum.map(fn {{x, y}, pixel} ->
				{{y, 9 - x}, pixel}
			end)
			|> Map.new

		{id, rotated}
	end

	defp flip({id, data}) do
		flipped =
			data
			|> Enum.map(fn {{x, y}, pixel} ->
				{{9 - x, y}, pixel}
			end)
			|> Map.new
		
		{id, flipped}
	end

	defp connects?(tile1, tile2, direction) do
		case direction do
			{0, -1} -> connects_top?(tile1, tile2)
			{1, 0} -> connects_right?(tile1, tile2)
			{0, 1} -> connects_bottom?(tile1, tile2)
			{-1, 0} -> connects_left?(tile1, tile2)
		end
		true
	end

	defp connects_top?(tile1, tile2) do
		top_border(tile1) == bottom_border(tile2)
	end

	defp connects_right?(tile1, tile2) do
		right_border(tile1) == left_border(tile2)
	end

	defp connects_bottom?(tile1, tile2) do
		bottom_border(tile1) == top_border(tile2)
	end

	defp connects_left?(tile1, tile2) do
		left_border(tile1) == right_border(tile2)
	end

	defp top_border(tile) do
		tile
		|> Enum.filter(fn {{_x, y}, pixel} -> y == 0 end)
		|> Enum.map(fn {{x, y}, pixel})
	end

	defp find_a_tile_missing_a_neighbor(canvas) do
		canvas
		|> Enum.find_value(fn tile = {{x, y}, data} ->
			missing = 
				[{0, -1}, {1, 0}, {0, 1}, {-1, 0}]
				|> Enum.find(fn {dx, dy} -> 
					not Map.has_key?(canvas, {x + dx, y + dy})
				end)
			
			if missing, do: {canvas, {tile, missing}}, else: false
		end)
	end

	defp pick_one_tile(_tile_bag = [first | rest]) do
		{rest, %{{0, 0} => first}}
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

	defp parse_tile([encoded_id | encoded_data]) do
		id = Regex.run(~r/Tile (\d+):/, encoded_id) |> Enum.at(1) |> Integer.parse |> elem(0)

		data =
			encoded_data
			|> Enum.with_index
			|> Enum.map(fn {row, y} ->
				row
				|> String.graphemes
				|> Enum.with_index
				|> Enum.map(fn {pixel, x} -> {{x, y}, pixel} end)
			end)
			|> List.flatten
			|> Map.new

		{id, data}
	end
end
